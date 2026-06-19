# SPDX-License-Identifier: Apache-2.0
$env:AUTOGUARDRAILS_TARGET_PROVIDER="openai_compatible"
$env:AUTOGUARDRAILS_TARGET_MODEL="glm-5.2"
$env:AUTOGUARDRAILS_TARGET_API_BASE="http://localhost:1234/v1"
$env:AUTOGUARDRAILS_TARGET_API_KEY="lm-studio"

$env:AUTOGUARDRAILS_JUDGE_PROVIDER="openai_compatible"
$env:AUTOGUARDRAILS_JUDGE_MODEL="glm-5.2"
$env:AUTOGUARDRAILS_JUDGE_API_BASE="http://localhost:1234/v1"
$env:AUTOGUARDRAILS_JUDGE_API_KEY="lm-studio"

Write-Host "Iniciando pruebas con LM Studio y el modelo glm-5.2..."
& "$PSScriptRoot\run_search_and_gate.ps1"
