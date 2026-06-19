# Copyright (c) 2026 Santander Group
# SPDX-License-Identifier: Apache-2.0
param (
    [string]$AutoguardrailsDir = "D:\Repo\autoguardrails-ccdd\engine",
    [string]$ContractDir = "D:\Repo\autoguardrails-ccdd\contract",
    [string]$CcddScript = "C:\Users\Administrador\.gemini\config\plugins\ccdd-plugin\resources\ccdd.py"
)

Write-Host "Iniciando iteración de Autoguardrails..."
# Copiamos la política actual al engine para que pueda mutarla
Copy-Item "$ContractDir\policies.txt" "$AutoguardrailsDir\policy.md" -Force

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
    Pop-Location
}

# Copiamos el resultado de vuelta
Copy-Item "$AutoguardrailsDir\policy.md" "$ContractDir\policies.txt" -Force

Write-Host "Validando el nuevo contrato con CCDD Gate..."
python $CcddScript lint $ContractDir
if ($LASTEXITCODE -ne 0) {
    Write-Error "CCDD Lint Gate falló. El nuevo policies.txt violó el presupuesto de tokens o las reglas del contrato."
    exit 1
}

Write-Host "Generando firmas actualizadas..."
python $CcddScript lint $ContractDir --sign

Write-Host "¡Iteración completada con éxito! El nuevo prompt respeta las reglas de CCDD."
