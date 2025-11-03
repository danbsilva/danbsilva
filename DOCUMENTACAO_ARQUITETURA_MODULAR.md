# 🏗️ Documentação - Arquitetura Modular do Agente IA

## 📋 Visão Geral

A arquitetura modular divide o sistema em **módulos independentes e reutilizáveis**, cada um com uma responsabilidade específica. Isso facilita:
- ✅ Manutenção e atualizações
- ✅ Reutilização em outros projetos
- ✅ Testes isolados
- ✅ Escalabilidade
- ✅ Colaboração em equipe

## 🎯 Estrutura Modular

```
┌─────────────────────────────────────────┐
│  Workflow Principal (Orquestrador)      │
│  n8n-agente-ia-modular.json             │
└──────────────┬──────────────────────────┘
               │
    ┌──────────┼──────────┬──────────────┬──────────────┐
    │          │          │              │              │
    ▼          ▼          ▼              ▼              ▼
┌────────┐ ┌────────┐ ┌────────┐   ┌────────┐   ┌────────┐
│ Módulo │ │ Módulo │ │ Módulo │   │ Módulo │   │ Módulo │
│Contexto│ │Intenção│ │Resposta│   │Escalação│  │ KB     │
└────────┘ └────────┘ └────────┘   └────────┘   └────────┘
```

## 📦 Módulos Disponíveis

### 1. **Módulo: Buscar Contexto**
**Arquivo**: `modulos/n8n-modulo-buscar-contexto.json`

**Responsabilidade**: Buscar e processar informações do ticket e histórico de conversa.

**Entrada**:
```json
{
  "ticketId": 123456
}
```

**Saída**:
```json
{
  "context": {
    "ticket": { ... },
    "requester": { ... },
    "conversation": {
      "history": [...],
      "messageCount": 5
    }
  }
}
```

**Uso**: Sempre executado primeiro para obter contexto.

---

### 2. **Módulo: Classificar Intenção**
**Arquivo**: `modulos/n8n-modulo-classificar-intencao.json`

**Responsabilidade**: Classificar a intenção da mensagem do cliente usando IA.

**Entrada**:
```json
{
  "message": "Preciso de ajuda com meu pedido",
  "context": { ... }
}
```

**Saída**:
```json
{
  "intent": "PEDIDO_STATUS",
  "confidence": "high",
  "rawResponse": "...",
  "classifiedAt": "2024-01-01T00:00:00Z"
}
```

**Categorias**:
- `INFO_GERAL`: Informações gerais
- `SUPORTE_TECNICO`: Problemas técnicos
- `PEDIDO_STATUS`: Consultas de status
- `RETENÇÃO`: Cancelamento/reembolso
- `ESCALACAO`: Solicitação de humano
- `OUTRO`: Outras intenções

---

### 3. **Módulo: Gerar Resposta**
**Arquivo**: `modulos/n8n-modulo-gerar-resposta.json`

**Responsabilidade**: Gerar resposta contextual usando IA baseada no histórico e intenção.

**Entrada**:
```json
{
  "message": "Qual o status do meu pedido?",
  "context": { ... },
  "intent": "PEDIDO_STATUS",
  "kbContext": [ ... ] // opcional
}
```

**Saída**:
```json
{
  "response": "Olá! Seu pedido está em trânsito...",
  "rawResponse": "...",
  "intent": "PEDIDO_STATUS",
  "generatedAt": "2024-01-01T00:00:00Z",
  "model": "gpt-4"
}
```

**Recursos**:
- Mantém contexto da conversa
- Integra conhecimento da KB (opcional)
- Personaliza baseado na intenção

---

### 4. **Módulo: Escalação**
**Arquivo**: `modulos/n8n-modulo-escalacao.json`

**Responsabilidade**: Decidir e executar escalação para agente humano quando necessário.

**Entrada**:
```json
{
  "ticketId": 123456,
  "context": { ... },
  "intent": "ESCALACAO",
  "message": "Preciso falar com um atendente"
}
```

**Saída**:
```json
{
  "escalated": true,
  "priority": "high",
  "reason": "ESCALAR",
  "summary": "...",
  "escalationData": { ... }
}
```

**Lógica**:
- Analisa contexto e intenção
- Usa IA para decidir escalação
- Atualiza ticket no Zendesk
- Adiciona nota interna

---

### 5. **Módulo: Knowledge Base**
**Arquivo**: `modulos/n8n-modulo-knowledge-base.json`

**Responsabilidade**: Buscar artigos relevantes na Knowledge Base do Zendesk.

**Entrada**:
```json
{
  "query": "como cancelar pedido",
  "limit": 5
}
```

**Saída**:
```json
{
  "query": "como cancelar pedido",
  "articles": [
    {
      "id": 123,
      "title": "Como cancelar um pedido",
      "body": "...",
      "url": "https://...",
      "relevance": 0.95
    }
  ],
  "count": 5,
  "found": true
}
```

**Uso**: Opcional, pode ser usado para enriquecer respostas.

---

## 🔄 Fluxo de Execução

```
1. Zendesk Trigger
   ↓
2. Extrair Dados + Filtrar
   ↓
3. Executar: Buscar Contexto
   ↓
4. Executar: Classificar Intenção (paralelo)
   Executar: Buscar KB (paralelo, opcional)
   ↓
5. Preparar Dados
   ↓
6. Executar: Gerar Resposta
   ↓
7. Executar: Verificar Escalação (paralelo)
   ↓
8. Decisão:
   - Se escalado: Finalizar
   - Se não escalado: Enviar Resposta
   ↓
9. Log: Execução
```

## 🚀 Instalação e Configuração

### Passo 1: Importar Módulos

Importe todos os módulos no n8n:

1. **Módulo Buscar Contexto**
   ```
   Workflows → Import → modulos/n8n-modulo-buscar-contexto.json
   ```

2. **Módulo Classificar Intenção**
   ```
   Workflows → Import → modulos/n8n-modulo-classificar-intencao.json
   ```

3. **Módulo Gerar Resposta**
   ```
   Workflows → Import → modulos/n8n-modulo-gerar-resposta.json
   ```

4. **Módulo Escalação**
   ```
   Workflows → Import → modulos/n8n-modulo-escalacao.json
   ```

5. **Módulo Knowledge Base** (opcional)
   ```
   Workflows → Import → modulos/n8n-modulo-knowledge-base.json
   ```

### Passo 2: Obter IDs dos Workflows

Para cada módulo importado:
1. Abra o workflow
2. Copie o **Workflow ID** da URL ou das configurações
3. Anote o ID

### Passo 3: Configurar Variáveis de Ambiente

Adicione estas variáveis no n8n:

```bash
# IDs dos workflows dos módulos
MODULO_BUSCAR_CONTEXTO_WORKFLOW_ID=workflow_id_aqui
MODULO_CLASSIFICAR_INTENCAO_WORKFLOW_ID=workflow_id_aqui
MODULO_GERAR_RESPOSTA_WORKFLOW_ID=workflow_id_aqui
MODULO_ESCALACAO_WORKFLOW_ID=workflow_id_aqui
MODULO_KB_WORKFLOW_ID=workflow_id_aqui  # opcional

# Outras variáveis (já existentes)
ZENDESK_AI_AGENT_ID=123456789
ZENDESK_BASE_URL=https://sua-empresa.zendesk.com
ZENDESK_HUMAN_AGENT_GROUP_ID=987654321
CONVERSATION_HISTORY_LIMIT=10
OPENAI_MODEL=gpt-4
OPENAI_TEMPERATURE=0.7
OPENAI_MAX_TOKENS=2000
```

### Passo 4: Importar Workflow Principal

```
Workflows → Import → n8n-agente-ia-modular.json
```

### Passo 5: Ativar Workflows

**Importante**: Ative TODOS os workflows (módulos + principal)

1. Vá em cada workflow
2. Clique em "Active" (toggle no topo)
3. Verifique que todos estão ativos

## 🧪 Testando os Módulos

### Teste Individual

Cada módulo pode ser testado isoladamente:

1. Abra o módulo
2. Clique em "Execute Workflow"
3. Use os dados de entrada de teste
4. Verifique a saída

### Teste de Integração

1. Crie ticket de teste no Zendesk
2. Envie mensagem
3. Verifique execuções em cada módulo
4. Valide resposta final

## 🔧 Customização de Módulos

### Personalizar Classificação

Edite `n8n-modulo-classificar-intencao.json`:
- Ajuste categorias no prompt
- Mude modelo de IA
- Adicione novas categorias

### Personalizar Geração de Resposta

Edite `n8n-modulo-gerar-resposta.json`:
- Ajuste prompt do sistema
- Configure temperatura/modelo
- Adicione mais contexto

### Personalizar Escalação

Edite `n8n-modulo-escalacao.json`:
- Ajuste critérios de escalação
- Configure prioridades
- Personalize notas internas

## 📊 Monitoramento

### Execuções por Módulo

No n8n, você pode ver:
- Execuções de cada módulo individualmente
- Execuções do workflow principal
- Tempo de execução de cada módulo
- Erros específicos por módulo

### Logs Centralizados

O workflow principal registra:
- Ticket ID
- Canal
- Intenção classificada
- Se foi escalado
- Previews de mensagem e resposta

## 🎯 Vantagens da Arquitetura Modular

### ✅ Manutenibilidade
- Cada módulo pode ser atualizado independentemente
- Bugs isolados em um módulo não afetam outros
- Fácil identificar onde fazer mudanças

### ✅ Reutilização
- Módulos podem ser usados em outros workflows
- Exemplo: Módulo de Classificação pode ser usado em outros sistemas
- Módulo KB pode ser reutilizado para outros fins

### ✅ Testabilidade
- Teste cada módulo isoladamente
- Valide entrada/saída de cada módulo
- Mock fácil para testes

### ✅ Colaboração
- Equipe pode trabalhar em módulos diferentes
- Reduz conflitos de merge
- Especialização por funcionalidade

### ✅ Escalabilidade
- Adicione novos módulos facilmente
- Remova módulos não utilizados
- Substitua módulos por versões melhoradas

## 🔄 Adicionando Novos Módulos

Para adicionar um novo módulo:

1. **Crie o workflow do módulo**
   - Defina entrada e saída claramente
   - Use nó "Manual Trigger" para testes

2. **Documente o módulo**
   - Entrada esperada
   - Saída gerada
   - Dependências

3. **Importe no n8n**

4. **Adicione ao workflow principal**
   - Use nó "Execute Workflow"
   - Configure workflow ID
   - Conecte entrada/saída

5. **Atualize variáveis de ambiente**
   - Adicione `MODULO_NOVO_WORKFLOW_ID`

## 📝 Boas Práticas

### Entrada/Saída Padronizada

Use formato consistente:
```json
{
  "ticketId": number,
  "message": string,
  "context": object,
  "intent": string
}
```

### Tratamento de Erros

Cada módulo deve:
- Validar entrada
- Tratar erros graciosamente
- Retornar estrutura de erro consistente

### Documentação

Mantenha:
- Descrição de cada módulo
- Exemplos de entrada/saída
- Dependências
- Changelog

### Versionamento

- Use tags no n8n para versionar módulos
- Mantenha versões anteriores para rollback
- Documente breaking changes

## 🐛 Troubleshooting

### Módulo não executa

- ✅ Verifique se workflow está ativado
- ✅ Confirme workflow ID nas variáveis
- ✅ Verifique permissões de execução

### Dados não passam corretamente

- ✅ Valide formato de entrada
- ✅ Confirme mapeamento no nó Execute Workflow
- ✅ Verifique logs de execução

### Performance lenta

- ✅ Otimize módulos individualmente
- ✅ Execute módulos em paralelo quando possível
- ✅ Cache resultados quando apropriado

## 📚 Exemplos de Uso

### Usar Apenas Classificação

```javascript
// Execute apenas o módulo de classificação
const intent = await executeWorkflow(
  MODULO_CLASSIFICAR_INTENCAO_WORKFLOW_ID,
  { message: "Preciso de ajuda", context: {...} }
);
```

### Usar KB em Outro Contexto

```javascript
// Execute módulo KB para busca genérica
const articles = await executeWorkflow(
  MODULO_KB_WORKFLOW_ID,
  { query: "política de reembolso" }
);
```

---

**Versão**: 1.0  
**Última atualização**: 2024  
**Arquitetura**: Modular com sub-workflows
