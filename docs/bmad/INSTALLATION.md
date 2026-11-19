# Instalação oficial do BMad Method — WIN-Trading-Engine

**Status:** scripts versionados; instalação oficial do runtime **pendente de execução em clone local**. Não confundir este documento com o BMad já instalado.

## Versão e decisão
- Escolha: **BMad Method v6.12.4**, ramo estável 6.12.
- Pacote oficial: `bmad-method@6.12.4` (npm).
- Módulo: `bmm` (BMad Method); IDE inicialmente **Codex**.
- Instalação: `_bmad/`, por meio do instalador oficial. Não copiar agentes manuais como substituto da distribuição.
- Por que não v7: linha em evolução; migração requer novo ADR.

Fontes oficiais:
- https://github.com/bmad-code-org/BMAD-METHOD/tree/V6.12 (documentação da linha escolhida)
- https://docs.bmad-method.org/start/install-bmad/ (documentação atual, com instruções de v7 em prévia)
- https://github.com/bmad-code-org/BMAD-METHOD/releases/tag/v6.12.4
- https://www.npmjs.com/package/bmad-method/v/6.12.4

## Pré-requisitos
Node.js >=20.12, npm, Git, Python >=3.10, `uv`, acesso à internet e Codex instalado. Revise os prompts e dependências de terceiros antes de conceder execução.

## Instalação no Windows
```powershell
git clone https://github.com/jadergreiner/WIN-Trading-Engine.git
cd WIN-Trading-Engine
git fetch origin
git switch feature/bmad-method-bootstrap
.\scripts\install-bmad.ps1
```

## Instalação em Linux/macOS
```bash
git clone https://github.com/jadergreiner/WIN-Trading-Engine.git
cd WIN-Trading-Engine
git fetch origin
git switch feature/bmad-method-bootstrap
bash scripts/install-bmad.sh
bash scripts/verify-bmad.sh
```

Os dois scripts executam o instalador oficial:

```bash
npx --yes bmad-method@6.12.4 install --directory . --modules bmm --tools codex --yes
```

O script de Linux/macOS passa o caminho absoluto do clone no argumento `--directory`, evitando depender da pasta atual. Se o instalador modificar opções nesta versão, interrompa a instalação e revise a CLI oficial; **não** substitua silenciosamente pela versão latest.

**Atenção às gerações:** a documentação principal atual usa a Skills CLI e `bmad setup` (linha v7 em prévia); este PR utiliza o instalador npm da **linha estável v6.12**. Não executar os dois modelos de instalação em paralelo. Para a linha v6, usar os comandos gerados pelo instalador, como `bmad-help`, e verificar os nomes exatos após instalar.

**Estado do CI:** as duas primeiras execuções do workflow de instalação falharam. Os logs não estavam acessíveis pela integração. Um commit posterior adicionou captura de saída em artefato de diagnóstico e removeu uma sondagem de versão que não era necessária. O êxito após essa mudança **ainda precisa ser comprovado**.


## Após a instalação
1. Verifique `_bmad/` e `_bmad/bmm/` e os comandos/skills efetivamente criados para Codex.
2. Abra o Codex na raiz do repositório e acione o workflow de help da versão instalada. Em v6 ele pode aparecer como `bmad-help`; confirme no catálogo gerado.
3. Registre versão, módulos e comando de instalação no PR.
4. Reveja arquivos gerados, segredos e permissões. Versione apenas os artefatos necessários e permitidos pela licença, sob PR adicional.
5. Não reutilize instruções da linha v7 (como `bmad setup`) como se fossem comprovadamente equivalentes na instalação v6.
6. A iniciativa começa em Analysis, baseada em `docs/bmad/prototype-assessment.md`. A próxima aprovação é o Product Brief/PRD, não infraestrutura AWS.

## Critérios de aceite
- [ ] Instalação oficial completa em clone limpo com versão 6.12.4, sem instalar latest.
- [ ] Comandos/skills BMad da IDE reconhecidos.
- [ ] Módulo BMM detectado e arquivo de configuração correto verificado.
- [ ] `AGENTS.md` permanece íntegro e regras de risco presentes.
- [ ] Teste de invocação de help executado, com resultado registrado no PR.
- [ ] Nenhum recurso AWS provisionado e nenhuma corretora conectada.
- [ ] Arquivos gerados inspecionados e commits revisados.

## Segurança
O repositório é público. Não salvar credenciais, chaves, token de API de corretora, histórico de mercado sem licença ou configuração privada em Git. A fase operacional é estritamente simulação.

## Próximos agentes/workflows
Usar os agentes oficiais disponíveis no catálogo v6 para: analyst (assessment), PM (product brief/PRD), architect (arquitetura e ADRs), PO/SM (épicos e histórias) e dev (implementação). Os nomes exatos devem ser descobertos após a instalação.
