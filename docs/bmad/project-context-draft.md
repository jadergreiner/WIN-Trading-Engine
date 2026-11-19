# WIN-Trading-Engine — Contexto de projeto para BMad

**Status:** proposta de diretrizes para revisão; sem aprovação de arquitetura ou produto.  
**Repositório:** https://github.com/jadergreiner/WIN-Trading-Engine  
**Data:** 2026-11-19

## Visão e limites
- Plataforma experimental de trading algorítmico de contratos WIN/B3 em Python e AWS.
- Primeira produção = **paper trading**: processamento real em infraestrutura real com **ordens exclusivamente virtuais**.
- Não conectar conta de corretora, transmitir ordens reais, aceitar chaves de negociação nem afirmar rentabilidade sem autorização, validações e revisão explícitas.
- Toda informação de preço deve carregar fonte, vencimento, timestamp, fuso, granularidade e licenciamento. Ausência de feed bloqueia sinal em tempo real, não justifica dados inventados.
- O produto deve possibilitar a decisão legítima de **não operar**.

## Princípios de engenharia
1. Segurança e risco são controles independentes, não parâmetros opcionais de estratégia.
2. Determinismo para backtest e replay: entrada, versão de código, parâmetros, fonte, checksum e saída rastreáveis.
3. Idempotência de sinais/ordens virtuais por IDs estáveis; concorrência e recuperação demonstradas em testes.
4. Não confundir simulação OHLC com execução de mercado. Custos, slippage, gaps, latência e incerteza declarados.
5. Posições virtuais, saldo e limites reconciliáveis após reinício, com detecção de inconsistências e fail-closed.
6. Estratégia única e simplicidade antes de ECS/serviços adicionais; justificativa baseada em SLO, volume e custos.
7. IaC com Terraform, CI, logs estruturados, alarmes, least privilege, proteção de segredos e controle de gasto antes de implantação.
8. Separar data plane da estratégia, controle de risco, simulador de execução e relatórios.
9. Mudanças por branches e PR; não fazer merge automático nem provisionar infraestrutura sem aprovação.
10. Manter ADRs com alternativas, trade-offs, contexto, evidências, impacto e decisão explícita.

## Escopo por marcos (proposto, não aprovado)
| Marco | Resultado verificável | Gate |
|---|---|---|
| M0 — Analysis | Avaliação do MVP, hipóteses, fontes e riscos | Avaliação revisada pelo responsável |
| M1 — Planejamento | Iniciativa BMad, épicos e critérios de aceite | Aprovação de escopo |
| M2 — Fundamentos | Pacote Python, testes determinísticos e CI no GitHub | Testes + revisão PR |
| M3 — Dados | Fonte WIN licenciada, qualidade e contratos versionados | Auditoria de dados |
| M4 — AWS paper | Execução isolada, logs, estado e kill switch | Testes de falhas, custo e segurança |
| M5 — Avaliação | Replay e paper trading com métricas e incidentes | Revisão humana de resultados |

## Gates que bloqueiam a evolução
- **Dados:** sem licenciamento, sem sincronização temporal ou sem vencimento verificável.
- **Risco:** sem stop simulado, sem limites duráveis, duplicidade não controlada, perda orçada ultrapassada e falta de reação a falhas.
- **Operação:** sem observabilidade, reconciliação, política de custos ou testes de recuperação.
- **Resultados:** sem dados reais, sem out-of-sample, métricas insuficientes ou pressupostos não documentados.
- **Ações externas:** qualquer transmissão de ordem ou inclusão de credenciais reais exige nova decisão de arquitetura, compliance e aprovação explícita.

## Workflow BMad
1. `bmad-project-context` para fixar princípios e restrições no código.
2. `bmad-agent-po`: escrever a iniciativa com base em `docs/bmad/prototype-assessment.md`.
3. `bmad-architecture`: resolver decisões transversais; registrar ADRs e dependências reais.
4. `bmad-agent-po`: adotar arquitetura, dividir em épicos, definir Done e histórias.
5. `bmad-build` por história, revisões e evidências nos PRs.
6. Retrospectiva e validação humana ao final de cada épico.

**Observação de método:** estes arquivos são preparação e não equivalem à execução dos agentes BMad em uma IDE configurada.

## Instalação oficial sugerida (a executar localmente)
Requisitos: Node/npm, Git, Python/uv e agente de programação compatível com Skills. Verificar a versão/tag do BMad escolhida e fixá-la.

```bash
npx skills add bmad-code-org/BMAD-METHOD/skills/core-tools --skill '*'
npx skills add bmad-code-org/BMAD-METHOD/skills/method --skill '*'
# no agente de código: bmad setup
# no agente de código: bmad status
```

Referências:
- https://docs.bmad-method.org/start/install-bmad/
- https://docs.bmad-method.org/scenarios/turn-a-prototype-into-a-product/
- https://docs.bmad-method.org/start/how-bmad-works/
