# 🧠 Cérebro do Agente IA - Módulos de Inteligência

## 🎯 O Que É o Cérebro?

O **Cérebro** é o conjunto de módulos puros de IA, sem dependências externas. São os componentes de inteligência que podem ser usados em qualquer projeto.

## 📦 Módulos do Cérebro

### 1. 🎯 **Classificador de Intenções**
**Arquivo**: `n8n-cerebro-classificador.json`

**Função**: Classifica a intenção de uma mensagem do cliente.

**Entrada**:
```json
{
  "message": "Qual o status do meu pedido?",
  "context": {
    "ticket": { ... },
    "conversation": { ... }
  }
}
```

**Saída**:
```json
{
  "success": true,
  "intent": "PEDIDO_STATUS",
  "confidence": "high",
  "message": "...",
  "timestamp": "..."
}
```

**Categorias**:
- `INFO_GERAL` - Informações gerais
- `SUPORTE_TECNICO` - Problemas técnicos
- `PEDIDO_STATUS` - Status de pedidos
- `RETENÇÃO` - Cancelamento/reembolso
- `ESCALACAO` - Solicitação de humano
- `OUTRO` - Outras intenções

---

### 2. 💬 **Gerador de Respostas**
**Arquivo**: `n8n-cerebro-gerador-resposta.json`

**Função**: Gera resposta contextual usando IA.

**Entrada**:
```json
{
  "message": "Preciso de ajuda",
  "intent": "INFO_GERAL",
  "context": { ... },
  "kbContext": [ ... ],
  "personality": "professional" // ou "friendly", "technical"
}
```

**Saída**:
```json
{
  "success": true,
  "response": "Olá! Como posso ajudá-lo hoje?",
  "intent": "INFO_GERAL",
  "timestamp": "..."
}
```

**Personalidades**:
- `professional` - Profissional e cordial (padrão)
- `friendly` - Amigável e descontraído
- `technical` - Preciso e técnico

---

### 3. 🎚️ **Decisor de Escalação**
**Arquivo**: `n8n-cerebro-escalacao.json`

**Função**: Decide se precisa escalar para humano.

**Entrada**:
```json
{
  "intent": "ESCALACAO",
  "message": "Preciso falar com humano",
  "context": { ... },
  "conversationCount": 3
}
```

**Saída**:
```json
{
  "success": true,
  "escalated": true,
  "priority": "high",
  "reason": "Solicitação explícita de atendimento humano",
  "recommendation": "Escalar para atendimento humano (Prioridade: high)"
}
```

**Lógica**:
- **Regras baseadas** (rápido, sem IA):
  - Intenção é ESCALACAO → Escalar
  - Intenção é RETENÇÃO → Escalar
  - Palavras-chave urgentes → Escalar
  - Muitas mensagens (5+) → Escalar
  
- **IA** (quando necessário):
  - Problemas técnicos complexos
  - Casos ambíguos
  - Análise de contexto

---

### 4. 🎼 **Orquestrador Completo**
**Arquivo**: `n8n-cerebro-orquestrador.json`

**Função**: Combina todos os módulos em uma única execução.

**Entrada**:
```json
{
  "message": "Olá, preciso de ajuda com meu pedido",
  "context": { ... }
}
```

**Saída**:
```json
{
  "success": true,
  "classification": {
    "intent": "PEDIDO_STATUS",
    "confidence": "high"
  },
  "response": {
    "text": "Olá! Vou verificar...",
    "intent": "PEDIDO_STATUS"
  },
  "escalation": {
    "escalated": false,
    "priority": "normal",
    "reason": "..."
  },
  "recommendation": "..."
}
```

---

## 🚀 Como Usar

### Opção 1: Usar Módulos Individualmente

1. **Importar módulo desejado**:
   ```
   n8n → Workflows → Import → cerebro/n8n-cerebro-classificador.json
   ```

2. **Executar manualmente**:
   - Clique em "Execute Workflow"
   - Veja resultados na saída

3. **Integrar em seu projeto**:
   - Use nó "Execute Workflow"
   - Configure workflow ID

### Opção 2: Usar Orquestrador Completo

1. **Importar todos os módulos**:
   - `n8n-cerebro-classificador.json`
   - `n8n-cerebro-gerador-resposta.json`
   - `n8n-cerebro-escalacao.json`

2. **Obter IDs dos workflows**

3. **Configurar variáveis**:
   ```bash
   CEREBRO_CLASSIFICADOR_WORKFLOW_ID=id_1
   CEREBRO_GERADOR_RESPOSTA_WORKFLOW_ID=id_2
   CEREBRO_ESCALACAO_WORKFLOW_ID=id_3
   ```

4. **Importar orquestrador**:
   ```
   n8n → Import → n8n-cerebro-orquestrador.json
   ```

5. **Executar**:
   - Execute o orquestrador
   - Veja decisão completa do cérebro

---

## 🎓 Exemplos de Uso

### Exemplo 1: Apenas Classificar

```javascript
// Execute: Cérebro Classificador
const input = {
  message: "Qual o horário de funcionamento?",
  context: {}
};

const result = await executeWorkflow(
  CEREBRO_CLASSIFICADOR_WORKFLOW_ID,
  input
);

console.log(result.intent); // "INFO_GERAL"
```

### Exemplo 2: Gerar Resposta

```javascript
// Execute: Cérebro Gerador
const input = {
  message: "Preciso de ajuda",
  intent: "INFO_GERAL",
  context: { ... },
  personality: "friendly"
};

const result = await executeWorkflow(
  CEREBRO_GERADOR_RESPOSTA_WORKFLOW_ID,
  input
);

console.log(result.response); // "Olá! Como posso ajudá-lo?"
```

### Exemplo 3: Decidir Escalação

```javascript
// Execute: Cérebro Escalação
const input = {
  intent: "ESCALACAO",
  message: "Preciso falar com supervisor",
  conversationCount: 2
};

const result = await executeWorkflow(
  CEREBRO_ESCALACAO_WORKFLOW_ID,
  input
);

if (result.escalated) {
  console.log(`Escalar com prioridade ${result.priority}`);
}
```

### Exemplo 4: Cérebro Completo

```javascript
// Execute: Orquestrador
const input = {
  message: "Meu pedido está atrasado, preciso de ajuda urgente",
  context: {
    ticket: { subject: "Pedido atrasado" },
    conversation: { messageCount: 1 }
  }
};

const brain = await executeWorkflow(
  CEREBRO_ORQUESTRADOR_WORKFLOW_ID,
  input
);

console.log("Intenção:", brain.classification.intent);
console.log("Resposta:", brain.response.text);
console.log("Escalar?", brain.escalation.escalated);
```

---

## ⚙️ Configuração

### Variáveis de Ambiente

```bash
# IDs dos Workflows (se usando orquestrador)
CEREBRO_CLASSIFICADOR_WORKFLOW_ID=workflow_id_1
CEREBRO_GERADOR_RESPOSTA_WORKFLOW_ID=workflow_id_2
CEREBRO_ESCALACAO_WORKFLOW_ID=workflow_id_3

# OpenAI (opcional, padrões)
OPENAI_MODEL=gpt-4  # ou gpt-3.5-turbo
OPENAI_TEMPERATURE=0.7
OPENAI_MAX_TOKENS=2000
```

### Credenciais

Apenas uma credencial necessária:
- **OpenAI API** - Para todos os módulos de IA

---

## 🎯 Vantagens do Cérebro

✅ **Independente**: Não precisa de Zendesk, APIs externas, etc.  
✅ **Reutilizável**: Use em qualquer projeto  
✅ **Testável**: Teste isoladamente cada módulo  
✅ **Modular**: Use apenas o que precisa  
✅ **Portátil**: Funciona em qualquer ambiente  

---

## 📊 Arquitetura

```
┌─────────────────────────────────────┐
│   Orquestrador (Opcional)          │
└──────────────┬──────────────────────┘
               │
    ┌──────────┼──────────┬──────────┐
    │          │          │          │
    ▼          ▼          ▼          ▼
┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│Classifi│ │Gerador │ │Escalação│ │  KB*   │
│cador   │ │Resposta│ │         │ │        │
└────────┘ └────────┘ └────────┘ └────────┘
    │          │          │          │
    └──────────┴──────────┴──────────┘
               │
          [Saída Final]
```

*KB = Knowledge Base (futuro)

---

## 🧪 Testando

### Teste Individual

Cada módulo pode ser testado isoladamente:

1. Abra o módulo
2. Clique "Execute Workflow"
3. Modifique dados de entrada no nó inicial
4. Veja resultados

### Teste Completo

1. Configure orquestrador
2. Execute com diferentes mensagens
3. Analise decisões do cérebro

---

## 📝 Personalização

### Ajustar Classificações

Edite `n8n-cerebro-classificador.json`:
- Adicione novas categorias no prompt
- Ajuste palavras-chave no código
- Modifique confiança das decisões

### Ajustar Personalidades

Edite `n8n-cerebro-gerador-resposta.json`:
- Adicione novas personalidades
- Modifique tom e estilo
- Ajuste prompts por intenção

### Ajustar Escalação

Edite `n8n-cerebro-escalacao.json`:
- Modifique regras baseadas
- Ajuste prompt da IA
- Mude critérios de prioridade

---

## 🔄 Integrando em Projetos

### Em Workflow n8n

```javascript
// Use nó "Execute Workflow"
{
  workflowId: CEREBRO_CLASSIFICADOR_WORKFLOW_ID,
  source: { message: "...", context: {...} }
}
```

### Em API Externa

Crie endpoint que chama o workflow via API do n8n:
```javascript
POST /webhook/cerebro
{
  "message": "...",
  "context": {...}
}
```

### Em Outro Sistema

Integre via webhooks ou APIs do n8n.

---

## 💰 Custos

- **Classificador**: ~$0.01-0.02 por classificação
- **Gerador**: ~$0.03-0.06 por resposta
- **Escalação**: ~$0.01-0.02 por análise (apenas se usar IA)

**Total por execução completa**: ~$0.05-0.10

**Economia**: Use GPT-3.5-turbo para reduzir em ~90%

---

## 🎯 Casos de Uso

- ✅ Chatbots independentes
- ✅ Sistemas de atendimento customizados
- ✅ Análise de mensagens
- ✅ Geração de respostas automáticas
- ✅ Decisão de roteamento
- ✅ Integração com qualquer plataforma

---

**Versão**: 1.0  
**Status**: ✅ Pronto para uso  
**Dependências**: Apenas OpenAI API
