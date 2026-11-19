#!/usr/bin/env bash
set -Eeuo pipefail

# Instalação reproduzível do BMad Method (stable) para WIN-Trading-Engine.
# Executar da raiz do repositório. Requer rede, Node.js >=20.12 e npm.
BMAD_VERSION="6.12.4"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v node >/dev/null || ! command -v npm >/dev/null; then
  echo "ERRO: instale Node.js >= 20.12 e npm." >&2
  exit 1
fi
node -e 'const a=process.versions.node.split(".").map(Number); if(a[0]<20 || (a[0]===20 && a[1]<12)) process.exit(1)' || { echo "Node.js >=20.12 requerido"; exit 1; }

if ! command -v git >/dev/null; then
  echo "ERRO: Git é obrigatório." >&2
  exit 1
fi

if [[ ! -d .git ]]; then
  echo "ERRO: execute dentro de um clone Git do repositório." >&2
  exit 1
fi

echo "Instalando bmad-method@${BMAD_VERSION} (BMM, Codex) na pasta ${ROOT}"
echo "Não usar @latest: versão fixada para reprodutibilidade."
npx --yes "bmad-method@${BMAD_VERSION}" install \
  --directory "$ROOT" \
  --modules bmm \
  --tools codex \
  --yes

bash scripts/verify-bmad.sh
echo "Instalação concluída. Revise e versione os artefatos oficiais gerados em _bmad/ e comandos de agentes."
