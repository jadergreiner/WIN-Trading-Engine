#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."
[[ -d _bmad ]] || { echo "FALHA: diretório _bmad/ ausente. Execute scripts/install-bmad.sh"; exit 1; }
[[ -d _bmad/bmm ]] || { echo "FALHA: módulo oficial BMM ausente em _bmad/bmm/"; exit 1; }
[[ -f _bmad/bmm/config.yaml || -f _bmad/config.toml || -f _bmad/_config/manifest.yaml ]] || {
  echo "AVISO: não foi encontrado arquivo de configuração conhecido. Inspecione o manifesto gerado pelo instalador.";
}
[[ -f AGENTS.md ]] || { echo "FALHA: AGENTS.md ausente."; exit 1; }
echo "OK: runtime BMad, módulo BMM e instruções de agentes detectados."
echo "Verifique os comandos da sua IDE e revise arquivos gerados antes de commitar."
