# Product Brief — WIN-Trading-Engine

**Status:** DRAFT / não aprovado  
**Data:** 2026-11-19  
**Método:** BMad Method (fase Analysis → Planning, artefato preliminar; não representa execução de um agente BMad)  
**Fonte:** [Avaliação do protótipo](prototype-assessment.md) e [contexto do projeto](project-context-draft.md)

## 1. Visão
Criar uma plataforma de pesquisa e **paper trading intradiário** do minicontrato WIN da B3, com estratégias sistemáticas reproduzíveis, execução virtual observável, políticas independentes de risco e operação gerenciada na AWS. Primeiro comprovar integridade, fidelidade e disciplina operacional; resultados de estratégias são hipóteses a testar, nunca garantias.

## 2. Problema
Resultados de backtests podem ser enganadores quando dependem de dados sem proveniência, look-ahead, preenchimentos irrealistas, custos subestimados, parâmetros sobreajustados ou estado não recuperável. Um robô que apenas gere sinais não fornece segurança para operação intradiária: é preciso bloquear sinais inválidos, reconciliar posições virtuais e demonstrar a resiliência do sistema sob falhas.

## 3. Público inicial e JTBD
**Usuário primário:** operador/pesquisador quantitativo intermediário, com experiência em Engenharia de Dados e interesse em validar estratégias sistemáticas para WIN sem expor capital real.

**JTBD:** Quando eu avaliar um setup intradiário, quero executar replay e paper trading com regras consistentes e limites auditáveis, para distinguir evidência de vantagem de ruído de mercado e entender por que o sistema decidiu operar ou não.

**Não usuários iniciais:** clientes finais de corretoras, gestores de carteira, usuários de ordens reais, copy trading ou recomendações financeiras individualizadas.

## 4. Proposta de valor
- Uma única regra de estratégia implementada como código testável, com execução controlada por dados e relógio.
- Backtesting determinístico e replay dos mesmos eventos, com hash da fonte, parâmetros, versão de código e suposições de preenchimento.
- Motor de risco com autoridade de veto e políticas imutáveis durante a sessão (mudanças somente com nova aprovação/versionamento).
- Paper trading com trilha de eventos auditável, reconciliação após falha e encerramento sem overnight.
- Relatórios que expliquem métricas, incerteza e limites dos dados, inclusive quando **nenhuma operação** for autorizada.

## 5. Escopo do primeiro MVP de produção (PAPER)
| Capacidade | Objetivo verificável | Fora do escopo |
|---|---|---|
| Ingestão | OHLCV WIN licenciado, vencimento e timezone explícitos, validação de sequência | Book/tick em tempo real, se licença não cobrir |
| Estratégia | ORB 5m com parâmetros versionados e sinal condicionado | Portfólio multiestratégia e IA preditiva |
| Backtest | Replay determinístico e resultados brutos/líquidos com custos ajustáveis | Declaração de rentabilidade |
| Risco | Tamanho da posição, perdas máximas, stop, kill switch e pausa por perdas | Alavancagem real, ordens reais |
| Execução | Fills simulados com premissas e tratamento de gaps documentados | Acesso a corretora |
| Estado | Posições virtuais, ledger de eventos e replay idempotente | Sistema de liquidação financeira |
| AWS | Deploy automatizado e auditável em ambiente isolado de paper trading | Provisionamento antes do gate de arquitetura |
| Operação | Logs, alarmes, runbook, reconciliação e política de custos | Alta frequência/submilissegundo |

## 6. Critérios de sucesso por dimensões
**Qualidade técnica**
- Mesma configuração, dataset e commit -> mesmos resultados de domínio, sem dependência da ordem física de execução.
- Todo sinal e operação virtual com ID estável; duplicatas/replay não alteram resultados financeiros virtuais.
- Todas as transições de estado inválidas são bloqueadas e auditadas.
- Condições de feed ausente, stale, fora de ordem, gaps e erro de persistência entram em fail-closed.

**Risco**
- Limites iniciais de simulação: 0,25% capital/trade, 1% perda/dia, 3% por semana, 1 contrato, 1 posição ativa, bloqueio após 3 perdas consecutivas, zero overnight. Valores são **hipóteses de teste**, sujeitos à análise humana e revisão.
- Com custos/slippage incluídos, posições rejeitadas não podem ultrapassar orçamento de risco.
- Testar explicitamente que o stop não garante o preço solicitado e que perdas acima do orçamento podem ocorrer sob gaps/falhas.

**Produto e evidência**
- Indicadores obrigatórios: número de sessões/trades, cobertura e qualidade do dado, expectativa líquida, profit factor, drawdown e distribuição por regime de mercado.
- Registros que sustentem ou refutem H1–H5 do diagnóstico.
- Nenhuma exigência de PnL positivo como condição para aceitação técnica do motor; lucratividade é hipótese de pesquisa separada.

**Operação AWS**
- IaC e custos documentados; logs estruturados; alertas de falha de dados/risco; runbook de interrupção/reinício; segredo nenhum em Git; nenhuma dependência de integração de corretora.
- SLOs específicos de frescor, latência e recuperação dependem de provedor e custo (a definir, não inventar).

## 7. Exemplo de jornada de uso
1. Selecionar dataset WIN, período, vencimento, versão de estratégia e configuração de custos.
2. Rodar validações (e receber recusa justificada quando o conjunto é inválido).
3. Executar backtest/replay com controle de risco; armazenar ledger, versão e checkpoints.
4. Conferir resultado em reais e em R, métricas e hipóteses de execução.
5. Promover a mesma implementação de estratégia ao simulador intradiário apenas após os gates de confiabilidade.
6. Visualizar eventos e alertas no dia; reconciliar e fechar posições virtuais antes do limite de sessão.

## 8. Riscos e dependências abertas
1. **Licenciamento e disponibilidade de dados:** fonte oficial/provedor ainda não escolhido; direitos de retenção e streaming a validar.
2. **Fidelidade de execução:** candles de 5m não comprovam posição na fila, liquidez e preenchimento; simulação deve declarar incerteza.
3. **Custos e viabilidade AWS:** necessidade de orçamento e limites de gastos.
4. **Resiliência:** armazenamento, idempotência, concorrência, timeouts e reconciliação ainda sem arquitetura aprovada.
5. **Validação estatística:** amostra fora do período de desenvolvimento e regimes variados ainda indisponíveis.
6. **Regulação e corretoras:** operação real excluída da fase atual; eventual nova fase requer revisão jurídica, operacional e de risco.

## 9. Trade-offs que arquitetura precisa resolver
- Serviço único Fargate versus desacoplamento por filas/eventos: comparar latência, operações, custo e recuperação.
- Persistência relacional versus DynamoDB/event log: consistência, consultas, trilha e replay.
- Simulação OHLC conservadora versus tick-level: fidelidade versus custo/licença.
- Operação em horário fixo versus processo contínuo: perdas de conectividade e horários de mercado.
- Controle de risco acoplado em processo versus serviço independente: fail-closed e isolamento de falhas.

## 10. Não objetivos
Não operar capital real, não emitir recomendações de investimento, não habilitar corretora, não construir HFT, não prometer ganho, não armazenar segredos, não provisionar AWS antes de orçamento e ADR.

## 11. Decisões requeridas do responsável
- [ ] Aprovar problema, persona e objetivo exclusivamente paper trading.
- [ ] Escolher provedor de dados e licença.
- [ ] Estabelecer orçamento AWS mensal e política de suspensão.
- [ ] Aprovar parâmetros iniciais e exceções dos limites simulados.
- [ ] Aprovar exigências mínimas de replay, rastreabilidade, reconciliação e segurança.
- [ ] Autorizar o PM/PO BMad a converter este brief em PRD e épicos.

**Próximo artefato após aceite:** PRD com requisitos FR/NFR numerados, critérios de aceite testáveis e matriz de rastreabilidade. Nenhuma aprovação implícita foi assumida.
