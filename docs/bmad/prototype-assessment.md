# BMad — Avaliação do protótipo WIN Backtest v0.3.0

**Data:** 2026-11-19  
**Estado:** Analysis / assessment, não aprovado para produção  
**Base:** MVP Python local v0.3.0 criado nesta conversa; código ainda **não** versionado no repositório na data desta avaliação  
**Rota BMad:** [Turn a Prototype into a Product](https://docs.bmad-method.org/scenarios/turn-a-prototype-into-a-product/)

## 1. Problema e propósito
Investigar se estratégias sistemáticas intradiárias sobre o minicontrato futuro de Ibovespa (WIN/B3) podem ser testadas com regras reproduzíveis, risco explícito, trilha auditável e execução virtual. Implantação-alvo: AWS **somente em paper trading** nesta etapa. Integração a corretoras e dinheiro real ficam fora do escopo até decisão humana posterior.

## 2. O que o protótipo implementa (conforme seus arquivos locais)
- CLI Python >=3.10 sem dependências externas; entrada CSV com `timestamp,symbol,open,high,low,close,volume`.
- Candles de 5 minutos com timestamp e offset, preços em ticks de 5 pontos, um vencimento por execução.
- Estratégia Opening Range Breakout: faixa 09:00–09:30; confirmação após 09:30; entrada na abertura do candle seguinte; no máximo uma entrada por sessão.
- Stop hipotético 150 pontos, alvo 300 pontos; liquidação intradiária até saída forçada.
- PnL teórico por contrato: R$0,20/ponto, custos e slippage parametrizáveis.
- Limites preliminares: risco/trade 0,25%, perda diária 1%, semanal 3%, um contrato, pausa após três perdas consecutivas.
- JSON com trades, eventos de risco e métricas; testes unitários incluídos no pacote local.
- Dados de demonstração são **sintéticos**. Os resultados numéricos não indicam desempenho real nem vantagem estatística.

## 3. Evidências e lacunas
| Dimensão | Evidência disponível | Lacuna / validação exigida |
|---|---|---|
| Reprodutibilidade | Testes técnicos e série sintética fornecidos com o MVP | CI no GitHub, hash do dataset, configuração, commit e comparação de saídas |
| Integridade temporal | Validação de ordem, offset e candles consecutivos | Sessões parciais, feriados, mudanças de contrato, leilões, timezone e dados de provedor |
| Execução | Preenchimento a partir de OHLC com hipótese conservadora de stop | Dados de tick/book, spread, fila, latência, gaps e sensitividade a slippage |
| Risco | Regras locais de dimensionamento e bloqueio | Recuperação após crash, persistência atômica, concorrência, orçamento durável, kill switch independente |
| Pesquisa | Único setup ORB com parâmetros fixos | Teste fora da amostra, regimes, custos reais, robustez e incerteza estatística |
| Operação AWS | Arquitetura conceitual | IaC, execução programada, IAM, logs, alarmes, custo e incident response |
| Governança | Uso de simulação declarado | Licenças de dados, retenção, alertas, critérios de release e decisão humana |

**Não comprovado:** retorno financeiro, fidelidade de execução, prontidão em AWS, confiabilidade de feeds ao vivo, adequação para negociação real.

## 4. Decisão sobre o protótipo
**Proposta: preservar como baseline de pesquisa, não promover diretamente a serviço de produção.** Importar posteriormente em PR próprio após revisão de código, testes e dependências. A decisão de manter ou reescrever módulos permanece em aberto até a avaliação técnica.

## 5. Hipóteses a falsificar
- H1: repetindo execução com mesmo código, configuração e dados, os resultados JSON de domínio serão idênticos.
- H2: nenhum sinal simulado gera entrada acima dos limites conservadores configurados.
- H3: reinício/duplicação de eventos não resulta em posições virtuais duplicadas.
- H4: custos, slippage, horário e rollover não destroem a robustez de resultados quando analisados fora da amostra.
- H5: operação e observabilidade em AWS são viáveis sem complexidade ou custo desproporcional.

## 6. Questões em aberto para o PO
1. Qual fonte legalmente licenciada de candles/ticks WIN e seus SLAs, custos e histórico disponível?
2. Critérios de aceitação para uma estratégia (incluindo janela out-of-sample e robustez), sem presumir retorno positivo?
3. Qual orçamento mensal AWS e janela diária efetiva de execução?
4. Quais alertas de risco e quais ações exigem aprovação humana?
5. Qual governança e limitação permanente para eventual integração futura com corretoras?

## 7. Próxima etapa BMad
Solicitar ao Product Owner (Sofia / `bmad-agent-po`) a **iniciativa** a partir deste diagnóstico; antes de histórias, passar pela arquitetura (`bmad-architecture`) e explicitar as decisões de persistência, idempotência e fronteira entre estratégia/risco/executor. Usar critérios claros de Done e aprovação humana. Nenhuma implantação AWS ou ordem real autorizada.
