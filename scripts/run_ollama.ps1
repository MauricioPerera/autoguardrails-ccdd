# SPDX-License-Identifier: Apache-2.0
$env:AUTOGUARDRAILS_TARGET_PROVIDER="openai_compatible"
$env:AUTOGUARDRAILS_TARGET_MODEL="devstral-small-2:24b-cloud"
$env:AUTOGUARDRAILS_TARGET_API_BASE="http://localhost:11434/v1"
$env:AUTOGUARDRAILS_TARGET_API_KEY="ollama"
$env:AUTOGUARDRAILS_TARGET_MAX_TOKENS="2048"

$env:AUTOGUARDRAILS_JUDGE_PROVIDER="openai_compatible"
$env:AUTOGUARDRAILS_JUDGE_MODEL="devstral-small-2:24b-cloud"
$env:AUTOGUARDRAILS_JUDGE_API_BASE="http://localhost:11434/v1"
$env:AUTOGUARDRAILS_JUDGE_API_KEY="ollama"
$env:AUTOGUARDRAILS_JUDGE_MAX_TOKENS="2048"

Remove-Item "$PSScriptRoot\..\engine\results.tsv" -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\..\engine\.autoguardrails" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Iniciando pruebas con Ollama y el modelo devstral-small-2:24b-cloud..."
& "$PSScriptRoot\run_search_and_gate.ps1"
