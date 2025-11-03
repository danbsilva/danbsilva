# 📊 Diagrama Visual do Fluxo de Suporte Pós-Venda

## Fluxo Completo

```mermaid
graph TD
    %% Gatilhos
    subgraph "📥 GATILHOS"
        direction TB
        G1[▶️ Gatilho 1: Zendesk On Ticket Create]
        G2[▶️ Gatilho 2: Zendesk On Ticket Update]
    end

    %% Orquestração N8N
    subgraph "⚙️ ORQUESTRAÇÃO N8N"
        direction LR
        M1(Nó Merge: Juntar Gatilhos)
        S1(Nó Set: Extrair Dados do Ticket)
        IF1{Nó IF: Trava de Segurança}
        H1(Nó HTTP: Buscar Cliente API)
        IA1(Nó IA: Classificar Intenção)
        S2(Nó Switch: Roteamento por Intenção)
        STOP(⏹️ Parar Fluxo)
    end
    
    %% Caminho A (Resolver Status)
    subgraph "🔵 CAMINHO A: JORNADA PÓS-COMPRA"
        direction TB
        H2A(Nó HTTP: Buscar Status Pedido API)
        IA2A(Nó IA: Gerar Resposta de Status)
        Z1A(Nó Zendesk: Enviar Resposta Pública)
        END_A(✅ RESOLVIDO)
    end

    %% Caminho B (Transbordo)
    subgraph "🟠 CAMINHO B: RETENÇÃO_CANCELAMENTO"
        direction TB
        IA2B(Nó IA: Gerar Nota Interna)
        Z1B(Nó Zendesk: Transbordo Inteligente)
        END_B(👤 FILA HUMANA)
    end
    
    %% Caminho C (Coletar Dados)
    subgraph "🟡 CAMINHO C: NECESSITA_ESCLARECIMENTO"
        direction TB
        Z1C(Nó Zendesk: Pedir CPF)
        END_C(⏳ PENDENTE)
    end
    
    %% Ligações principais
    G1 --> M1
    G2 --> M1
    M1 --> S1
    S1 --> IF1
    IF1 -->|"✅ É Cliente<br/>(Continuar)"| H1
    IF1 -->|"🛑 É o Bot<br/>(Parar)"| STOP
    H1 --> IA1
    IA1 -->|"Prompt 1:<br/>Classificação"| S2

    %% Caminho A
    S2 -->|"Intenção:<br/>JORNADA_PÓS_COMPRA"| H2A
    H2A --> IA2A
    IA2A -->|"Prompt 3:<br/>Resposta de Status"| Z1A
    Z1A -->|"JSON:<br/>(public: true,<br/>author_id: LIA)"| END_A

    %% Caminho B
    S2 -->|"Intenção:<br/>RETENÇÃO_CANCELAMENTO"| IA2B
    IA2B -->|"Prompt 2:<br/>Nota de Transbordo"| Z1B
    Z1B -->|"JSON:<br/>(public: false,<br/>campos, atribuir)"| END_B

    %% Caminho C
    S2 -->|"Intenção:<br/>NECESSITA_ESCLARECIMENTO"| Z1C
    Z1C -->|"JSON:<br/>(public: true,<br/>author_id: LIA)"| END_C

    %% Estilos
    classDef gatilho fill:#4CAF50,stroke:#2E7D32,stroke-width:2px,color:#fff
    classDef processamento fill:#2196F3,stroke:#1565C0,stroke-width:2px,color:#fff
    classDef ia fill:#9C27B0,stroke:#6A1B9A,stroke-width:2px,color:#fff
    classDef decisao fill:#FF9800,stroke:#E65100,stroke-width:2px,color:#fff
    classDef sucesso fill:#4CAF50,stroke:#2E7D32,stroke-width:3px,color:#fff
    classDef transbordo fill:#FF5722,stroke:#BF360C,stroke-width:3px,color:#fff
    classDef pendente fill:#FFC107,stroke:#F57F17,stroke-width:3px,color:#000
    classDef parar fill:#F44336,stroke:#C62828,stroke-width:3px,color:#fff

    class G1,G2 gatilho
    class M1,S1,H1,H2A processamento
    class IA1,IA2A,IA2B ia
    class IF1,S2 decisao
    class END_A sucesso
    class END_B transbordo
    class END_C pendente
    class STOP parar
```

## 📋 Legenda de Cores

| Cor | Tipo de Nó | Descrição |
|-----|-----------|-----------|
| 🟢 Verde | Gatilhos e Sucesso | Triggers do Zendesk e resolução automática |
| 🔵 Azul | Processamento | Nós de transformação de dados e chamadas HTTP |
| 🟣 Roxo | IA | Nós que usam modelos de linguagem (GPT-4) |
| 🟠 Laranja | Decisão | Nós de controle de fluxo (IF, Switch) |
| 🔴 Vermelho | Parada | Interrupção do fluxo (loop prevention) |
| 🟡 Amarelo | Pendente | Aguardando ação do cliente |

## 📊 Estatísticas por Caminho

### 🔵 Caminho A: JORNADA_PÓS_COMPRA
- **Objetivo:** Resolução automática
- **Nós:** 3 (HTTP → IA → Zendesk)
- **Tempo estimado:** 5-10 segundos
- **Taxa de sucesso esperada:** 70-80%

### 🟠 Caminho B: RETENÇÃO_CANCELAMENTO
- **Objetivo:** Transbordo inteligente
- **Nós:** 2 (IA → Zendesk)
- **Tempo estimado:** 3-5 segundos
- **Prioridade:** ALTA
- **SLA:** Atendimento humano em < 5 min

### 🟡 Caminho C: NECESSITA_ESCLARECIMENTO
- **Objetivo:** Coleta de informações
- **Nós:** 1 (Zendesk)
- **Tempo estimado:** 2-3 segundos
- **Taxa de resposta do cliente:** 60-70%

## 🔄 Fluxo de Dados

### Entrada (Zendesk Trigger)
```json
{
  "id": "12345",
  "subject": "Onde está meu pedido?",
  "description": "Comprei há 3 dias...",
  "status": "new",
  "requester": {
    "email": "cliente@example.com",
    "name": "João Silva"
  },
  "comment": {
    "author_id": "987654"
  }
}
```

### Transformação (Set Node)
```json
{
  "ticket_id": "12345",
  "ticket_subject": "Onde está meu pedido?",
  "ticket_description": "Comprei há 3 dias...",
  "ticket_status": "new",
  "requester_email": "cliente@example.com",
  "requester_name": "João Silva",
  "latest_comment_author_id": "987654"
}
```

### Classificação (IA Node)
```json
{
  "output": "JORNADA_PÓS_COMPRA"
}
```

### Resposta Final (Zendesk Update)
```json
{
  "ticket": {
    "id": "12345",
    "status": "solved",
    "comment": {
      "body": "Olá João! Seu pedido #67890 está em trânsito...",
      "public": true,
      "author_id": "LIA_BOT_ID"
    }
  }
}
```

## 🎯 Pontos de Decisão

### 1️⃣ Trava de Segurança (IF)
```
SE latest_comment_author_id ≠ LIA_BOT_ID
  ENTÃO → Continuar processamento
  SENÃO → Parar fluxo (evitar loop)
```

### 2️⃣ Classificação de Intenção (Switch)
```
CASE classificacao:
  QUANDO "JORNADA_PÓS_COMPRA"
    → Caminho A (Buscar status + Responder)
  QUANDO "RETENÇÃO_CANCELAMENTO"
    → Caminho B (Nota interna + Transbordo)
  QUANDO "NECESSITA_ESCLARECIMENTO"
    → Caminho C (Pedir mais informações)
  PADRÃO
    → Caminho C (Seguro)
```

## 🚀 Otimizações Futuras

1. **Cache de dados do cliente** (Redis)
2. **Análise de sentimento** (positivo/negativo/neutro)
3. **Histórico de interações** (contexto expandido)
4. **A/B Testing** de prompts
5. **Feedback loop** (aprendizado contínuo)

## 📈 KPIs do Fluxo

| Métrica | Target | Medição |
|---------|--------|---------|
| Taxa de Automação | > 60% | Tickets resolvidos sem humano / Total |
| Tempo Médio de Resposta | < 30s | Tempo até primeira resposta automática |
| Acurácia de Classificação | > 85% | Classificações corretas / Total |
| Taxa de Transbordo | < 30% | Tickets transferidos / Total |
| CSAT (Customer Satisfaction) | > 4.0/5.0 | Feedback do cliente |

---

**💡 Dica:** Use este diagrama como referência para explicar o fluxo à equipe ou para debugging.
