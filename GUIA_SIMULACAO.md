# 🧪 Guia de Simulação - Testar sem Zendesk

## 🎯 O Que Este Workflow Faz

Este workflow permite testar todo o sistema de Agente IA **sem precisar do Zendesk configurado**. Ele:
- ✅ Simula dados do Zendesk
- ✅ Processa com IA real (GPT-4)
- ✅ Mostra resultados no console
- ✅ Permite testar toda lógica sem integração

## 🚀 Como Usar

### Passo 1: Importar Workflow

```
n8n → Workflows → Import from File
Selecione: n8n-agente-ia-simulacao.json
```

### Passo 2: Configurar Credencial OpenAI

Você ainda precisa da credencial OpenAI:

```
n8n → Credentials → Add
Tipo: OpenAI API
API Key: sk-... [de https://platform.openai.com/api-keys]
Nome: "OpenAI API"
```

### Passo 3: Executar Teste

1. **Abra o workflow importado**
2. **Clique em "Execute Workflow"** (botão no topo direito)
3. **Aguarde processamento** (10-30 segundos)
4. **Veja os resultados**:
   - No console do n8n
   - Na saída de cada nó
   - No nó "Log: Execução"

## 📊 O Que Você Verá

### No Console

```
=== RESPOSTA DO BOT ===
Ticket ID: 123456
Resposta: Olá! Entendo que você precisa de ajuda...
=======================

=== ESCALAÇÃO ===
Ticket ID: 123456
Escalado: false
Razão: CONTINUAR
================

=== LOG DE EXECUÇÃO ===
{
  "timestamp": "2024-01-01T00:00:00Z",
  "ticketId": 123456,
  "channel": "whatsapp",
  "intent": "PEDIDO_STATUS",
  "escalated": false,
  "messagePreview": "Olá, preciso de ajuda...",
  "responsePreview": "Olá! Entendo que você precisa..."
}
========================
```

### Nos Nós do Workflow

Clique em cada nó após execução para ver:
- **Mock: Dados do Zendesk**: Dados simulados
- **IA: Classificar Intenção**: Intenção detectada
- **IA: Gerar Resposta**: Resposta gerada
- **Processar Escalação**: Decisão de escalação

## 🔧 Personalizar Dados de Teste

### Modificar Mensagem do Cliente

Edite o nó **"Mock: Dados do Zendesk"**:

```javascript
const simulatedData = {
  ticket_id: 123456,
  id: 789012,
  body: "SUA MENSAGEM AQUI", // ← Modifique aqui
  author_id: 999999,
  author_email: "cliente@exemplo.com",
  public: true,
  channel: "whatsapp", // ou "chat", "email", "web"
  created_at: new Date().toISOString()
};
```

### Exemplos de Mensagens para Testar

#### Teste 1: Pedido de Status
```javascript
body: "Qual o status do meu pedido 12345?"
```

#### Teste 2: Escalação
```javascript
body: "Preciso falar com um atendente humano urgentemente"
```

#### Teste 3: Informação Geral
```javascript
body: "Quais são os horários de atendimento?"
```

#### Teste 4: Retenção
```javascript
body: "Quero cancelar minha compra e pedir reembolso"
```

#### Teste 5: Suporte Técnico
```javascript
body: "Meu produto não está funcionando, como resolvo?"
```

## 📋 Fluxo do Workflow Simulado

```
1. Simular: Novo Comentário (Manual Trigger)
   ↓
2. Mock: Dados do Zendesk (Cria dados falsos)
   ↓
3. Extrair Dados (Mesmo processo real)
   ↓
4. Filtrar: Comentário Válido
   ↓
5. Mock: Buscar Contexto (Simula ticket e histórico)
   ↓
6. IA: Classificar Intenção (IA REAL)
   ↓
7. Mock: Buscar KB (Simula KB vazia)
   ↓
8. IA: Gerar Resposta (IA REAL)
   ↓
9. Verificar Escalação (IA REAL)
   ↓
10. Simular: Enviar Resposta (Console apenas)
   ↓
11. Log: Execução (Resumo completo)
```

## 🎯 O Que É Simulado vs Real

| Componente | Status | Nota |
|------------|--------|------|
| **Dados do Zendesk** | ✅ Simulado | Mock local |
| **Contexto do Ticket** | ✅ Simulado | Mock local |
| **Knowledge Base** | ✅ Simulado | Retorna vazio |
| **Classificação de Intenção** | ✅ **IA REAL** | GPT-4 real |
| **Geração de Resposta** | ✅ **IA REAL** | GPT-4 real |
| **Escalação** | ✅ **IA REAL** | GPT-4 real |
| **Envio ao Zendesk** | ✅ Simulado | Apenas console |

## 💰 Custos

Este workflow **usa IA real** (GPT-4), então:
- ✅ Cada execução custa ~$0.03-0.06
- ✅ Use para testes importantes
- ✅ Para testes frequentes, considere usar GPT-3.5-turbo

### Mudar para GPT-3.5 (Mais Barato)

Edite nós de IA:
- "IA: Classificar Intenção"
- "IA: Gerar Resposta"  
- "IA: Classificar Escalação"

Altere `model` de `"gpt-4"` para `"gpt-3.5-turbo"`

## ✅ Checklist de Teste

Teste com diferentes mensagens:

- [ ] Mensagem de status de pedido
- [ ] Mensagem solicitando escalação
- [ ] Mensagem de informação geral
- [ ] Mensagem de cancelamento/retenção
- [ ] Mensagem de suporte técnico
- [ ] Mensagem vazia ou inválida
- [ ] Mensagem muito longa

## 🐛 Troubleshooting

### ❌ Erro: "OpenAI API Key invalid"
**Solução**: Configure credencial OpenAI no n8n

### ❌ Erro: "Cannot read property..."
**Solução**: Verifique que todos os nós anteriores executaram com sucesso

### ❌ Resposta não aparece
**Solução**: 
- Clique no nó "Simular: Enviar Resposta"
- Veja a saída do nó
- Ou verifique console do n8n

### ❌ IA não responde corretamente
**Solução**:
- Ajuste prompts nos nós de IA
- Verifique que modelo está configurado
- Teste com mensagens mais claras

## 🎓 Próximos Passos

Depois de testar com simulação:

1. **Valide que IA está funcionando** ✅
2. **Ajuste prompts se necessário** ✅
3. **Teste diferentes cenários** ✅
4. **Configure Zendesk real** (veja `INTEGRACAO_PASSO_A_PASSO.md`)
5. **Migre para workflow real** (importe `n8n-agente-ia-zendesk.json`)

## 📝 Notas

- ✅ Este workflow **não cria tickets reais** no Zendesk
- ✅ Use para **desenvolvimento e testes**
- ✅ Todas as respostas aparecem no **console/logs**
- ✅ **IA funciona normalmente** (classificação, geração, escalação)
- ✅ **Perfeito para validar lógica** antes de integrar

---

**Versão**: 1.0  
**Uso**: Desenvolvimento e testes  
**Requer**: OpenAI API Key
