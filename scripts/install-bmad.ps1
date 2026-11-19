$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $root

# Stable BMad Method; mesma versão do bootstrap Linux/macOS.
$version = "6.12.4"
if (-not (Get-Command node -ErrorAction SilentlyContinue) -or -not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "Node.js >= 20.12 e npm sao necessarios."
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git e necessario."
}
if (-not (Test-Path ".git")) {
    throw "Execute a partir de um clone Git."
}
$nodeVersion = [version]((& node --version).TrimStart("v"))
if ($nodeVersion -lt [version]"20.12.0") {
    throw "Node.js >=20.12 requerido."
}

Write-Host "Instalando bmad-method@$version para Codex/BMM em $root"
& npx.cmd --yes "bmad-method@$version" install --directory "$root" --modules bmm --tools codex --yes
if ($LASTEXITCODE -ne 0) { throw "Falha na instalacao oficial do BMad." }
if (-not (Test-Path "_bmad/bmm")) { throw "Instalacao incompleta: _bmad/bmm nao encontrado." }
if (-not (Test-Path "AGENTS.md")) { throw "AGENTS.md ausente." }
Write-Host "BMad instalado. Revise os arquivos gerados e versione os artefatos oficiais."
