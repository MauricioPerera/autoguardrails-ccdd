# SPDX-License-Identifier: Apache-2.0
param (
    [string]$AutoguardrailsDir = "$PSScriptRoot\..\engine",
    [string]$ContractDir = "$PSScriptRoot\..\contract",
    [string]$CcddCommand = "ccdd"
)

Write-Host "Iniciando iteración de Autoguardrails..."
# Copiamos la política actual al engine para que pueda mutarla
Copy-Item "$ContractDir\policies.txt" "$AutoguardrailsDir\policy.md" -Force

Write-Host "Inyectando timeout de 3600s en el motor para soportar LLMs locales..."
$ConfigFile = "$AutoguardrailsDir\autoguardrails\config.py"
if (Test-Path $ConfigFile) {
    (Get-Content $ConfigFile) -replace 'wall_clock_seconds:\s*int\s*=\s*\d+', 'wall_clock_seconds: int = 3600' | Set-Content $ConfigFile
}

Push-Location $AutoguardrailsDir
try {
    # Ejecutamos el baseline si no existe
    if (-not (Test-Path "results.tsv")) {
        Write-Host "Generando baseline inicial..."
        python -m autoguardrails baseline --reset --repeat 1 --notes "Baseline init"
    }
    
    # Ejecuta el candidato de autoguardrails
    Write-Host "Evaluando candidato..."
    python -m autoguardrails candidate --repeat 1 --notes "Automated CCDD search"
} finally {
    if (Test-Path $ConfigFile) {
        git -C "$AutoguardrailsDir" restore autoguardrails/config.py
    }
    Pop-Location
}

# Copiamos el resultado de vuelta
Copy-Item "$AutoguardrailsDir\policy.md" "$ContractDir\policies.txt" -Force

Write-Host "Validando el nuevo contrato con CCDD Gate..."
Invoke-Expression "$CcddCommand lint `"$ContractDir`""
if ($LASTEXITCODE -ne 0) {
    Write-Error "CCDD Lint Gate falló. El nuevo policies.txt violó el presupuesto de tokens o las reglas del contrato."
    exit 1
}

Write-Host "Generando hash de integridad actualizado..."
Invoke-Expression "$CcddCommand lint `"$ContractDir`" --sign"

Write-Host "¡Iteración completada con éxito! El nuevo prompt respeta las reglas de CCDD."
