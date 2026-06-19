# Copyright (c) 2026 Santander Group
# SPDX-License-Identifier: Apache-2.0
$env:AUTOGUARDRAILS_TARGET_PROVIDER="openai_compatible"
$env:AUTOGUARDRAILS_TARGET_MODEL="gemma-4-12b-coder-fable5-composer2.5-v1@q4_k_m"
$env:AUTOGUARDRAILS_TARGET_API_BASE="http://localhost:1234/v1"
$env:AUTOGUARDRAILS_TARGET_API_KEY="lm-studio"

$env:AUTOGUARDRAILS_JUDGE_PROVIDER="openai_compatible"
$env:AUTOGUARDRAILS_JUDGE_MODEL="gemma-4-12b-coder-fable5-composer2.5-v1@q4_k_m"
$env:AUTOGUARDRAILS_JUDGE_API_BASE="http://localhost:1234/v1"
$env:AUTOGUARDRAILS_JUDGE_API_KEY="lm-studio"

Write-Host "Iniciando pruebas con LM Studio y el modelo Gemma 12B..."
& "D:\Repo\autoguardrails-ccdd\scripts\run_search_and_gate.ps1"
