# AGENTS.md — WIN-Trading-Engine

## Governança
- Utilize o **BMad Method oficial instalado por `scripts/install-bmad.sh`**, versão do instalador fixada em `6.12.4`. Não invente nomes de workflows ou resultados de agentes.
- Antes de gerar código, leia `docs/bmad/prototype-assessment.md`, `docs/bmad/project-context-draft.md` e a iniciativa ativa, se existir.
- Siga o ciclo: Analysis → Planning → Architecture → Implementation → Review. Entre etapas, exija critérios de aceite e decisão humana registrada.
- Nenhum documento em draft representa aprovação. ADRs devem documentar contexto, alternativas, trade-offs, decisão, risco e evidências.
- Use branch por história, PR sem merge automático, testes reproduzíveis e registro de limitações.
- Não provisionar AWS, gastar recursos ou abrir integração com corretora sem autorização explícita.
- Não instalar dependências novas sem verificar origem, licença e manutenção.

## Limites do sistema de trading
- Escopo atual é pesquisa e paper trading. **Proibida execução de ordens reais** nesta etapa.
- Motor de risco independente do motor de estratégia, fail closed em ausência de dados, estado ou integridade.
- Sem look-ahead em backtests. Toda operação deve vincular ID idempotente, dataset (hash), vencimento WIN, fuso, timestamp, configuração, código, custos e slippage.
- A geração de sinal não equivale a execução. Modelar preenchimento, posição e reconciliação de forma separada.
- Não afirmar edge, lucro, aderência regulatória ou prontidão de produção sem evidências verificadas.
- Não guardar tokens, credenciais ou dados licenciados no repositório público.

## Workflow recomendado após a instalação
1. Invocar analista BMad para avaliar protótipo, dados e hipóteses.
2. Invocar PM/PO BMad para brief e PRD.
3. Invocar arquiteto BMad para arquitetura e ADRs.
4. Converter a arquitetura em épicos/histórias com critérios de aceite.
5. Implementar cada história apenas após aprovação de escopo, testes e revisão de PR.

## Definition of Done por história
- Critérios de aceite rastreáveis e testes automatizados verdes.
- Sem regressão de risco, duplicidade, limites ou integridade de dados.
- Cenários negativos e recuperação de falhas tratados.
- Métricas/observabilidade proporcionais ao risco.
- Atualização de docs/ADRs e PR revisado; sem merge automático.
