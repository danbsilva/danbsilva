# 🤖 Agente de IA Integrado ao Zendesk - Documentação Completa

## 📋 Visão Geral

Este workflow do n8n cria um **Agente de IA conversacional** totalmente integrado ao Zendesk que:
- ✅ Atende clientes via **WhatsApp**, **Chat**, **Email** e outros canais
- ✅ Mantém **contexto** da conversa através do histórico
- ✅ Escala automaticamente para **agentes humanos** quando necessário
- ✅ Usa **GPT-4** para respostas naturais e contextuais
- ✅ Registra todas as interações para análise

## 🏗️ Arquitetura do Sistema

```
WhatsApp/Chat/Email
        ↓
    Zendesk (Fila)
        ↓
   Webhook N8N
        ↓
   Agente IA (GPT-4)
        ↓
   Resposta/Escalação
        ↓
    Zendesk → Cliente
```

## 🚀 Instalação e Configuração

### 1. Pré-requisitos

- **n8n** instalado e rodando (Cloud ou Self-hosted)
- **Zendesk** com API habilitada
- **OpenAI API Key** (GPT-4)
- Acesso administrativo ao Zendesk

### 2. Importar Workflow no n8n

1. Acesse seu n8n
2. Vá em **Workflows** → **Import from File**
3. Selecione o arquivo `n8n-agente-ia-zendesk.json`
4. O workflow será importado com todos os nós

### 3. Configurar Credenciais no n8n

#### 3.1. Credencial Zendesk API
- **Tipo**: Zendesk API
- **Nome**: `Zendesk API`
- **Campos necessários**:
  - **Subdomain**: `sua-empresa` (sua-empresa.zendesk.com)
  - **Email**: `seu-email@exemplo.com`
  - **API Token**: [Obter no Zendesk: Admin → Apps and integrations → APIs → Zendesk API]

#### 3.2. Credencial Zendesk HTTP Auth
- **Tipo**: HTTP Header Auth
- **Nome**: `Zendesk HTTP Auth`
- **Configuração**:
  - **Header Name**: `Authorization`
  - **Header Value**: `Basic [BASE64(email:token)]`
  - Exemplo: `Basic dXNlckBleGVtcGxvLmNvbS90b2tlbjpzZXVUb2tlbkFwaQ==`
  - Gerar Base64: `echo -n "email@exemplo.com/token:seuTokenApi" | base64`

#### 3.3. Credencial OpenAI API
- **Tipo**: OpenAI API
- **Nome**: `OpenAI API`
- **Campos necessários**:
  - **API Key**: [Obter em https://platform.openai.com/api-keys]

### 4. Configurar Variáveis de Ambiente

No n8n, vá em **Settings** → **Environment Variables** e adicione:

```bash
# ID do Agente IA no Zendesk (usuário que representa o bot)
ZENDESK_AI_AGENT_ID=123456789

# URL base do Zendesk (sem /api/v2)
ZENDESK_BASE_URL=https://sua-empresa.zendesk.com

# ID do Grupo de Agentes Humanos (para escalação)
ZENDESK_HUMAN_AGENT_GROUP_ID=987654321
```

### 5. Obter IDs Necessários do Zendesk

#### 5.1. ID do Agente IA
1. No Zendesk, crie um usuário para representar o bot (ex: "LIA - Agente Virtual")
2. Vá em **Admin** → **Team** → **Agents**
3. Clique no usuário e copie o **User ID** da URL
4. Cole no `ZENDESK_AI_AGENT_ID`

#### 5.2. ID do Grupo de Agentes Humanos
1. No Zendesk, vá em **Admin** → **Team** → **Groups**
2. Selecione ou crie o grupo de atendimento humano
3. Copie o **Group ID** da URL
4. Cole no `ZENDESK_HUMAN_AGENT_GROUP_ID`

### 6. Configurar Webhook no Zendesk

O workflow usa o **Zendesk Trigger** que cria automaticamente webhooks. Mas para garantir:

1. No Zendesk, vá em **Admin** → **Apps and integrations** → **Webhooks**
2. Verifique se há webhooks criados pelo n8n
3. Se necessário, crie manualmente:
   - **Endpoint URL**: `[URL do seu n8n]/webhook/zendesk-new-comment`
   - **Request method**: POST
   - **Request format**: JSON
   - **Triggers**: Ticket created, Ticket updated, Comment created

## ⚙️ Como Funciona

### Fluxo de Execução

1. **Gatilho**: Cliente envia mensagem via WhatsApp/Chat/Email
2. **Zendesk recebe**: Cria/atualiza ticket e dispara webhook
3. **n8n captura**: Webhook ativa o workflow
4. **Filtragem**: Verifica se é mensagem pública do cliente (não do bot)
5. **Busca contexto**: Obtém informações do ticket e histórico de comentários
6. **Prepara contexto**: Formata histórico para a IA
7. **IA processa**: GPT-4 gera resposta contextual baseada no histórico
8. **Verifica escalação**: Analisa se precisa escalar para humano
9. **Responde ou escala**: Envia resposta ao cliente ou transfere para humano
10. **Log**: Registra execução para monitoramento

### Características do Agente IA

- **Memória de conversa**: Mantém contexto das últimas 10 mensagens
- **Multi-canal**: Funciona em WhatsApp, Chat, Email, Web
- **Empático**: Respostas naturais e humanizadas
- **Escalação inteligente**: Identifica quando precisa de humano
- **Histórico completo**: Acessa todo contexto do ticket

## 🎯 Personalização

### Ajustar Prompt do Sistema

Edite o nó **"IA: Gerar Resposta"** e personalize o prompt do sistema:

```markdown
Você é um assistente virtual de atendimento ao cliente especializado e amigável. 
Você atende clientes através do Zendesk em múltiplos canais (WhatsApp, Chat, Email).

[Adicione informações sobre sua empresa, produtos, políticas, etc.]

IMPORTANTE:
- Seja sempre cordial, profissional e empático
- Use linguagem natural e conversacional
- Mantenha respostas concisas mas completas
- [Suas regras específicas]
```

### Adicionar Base de Conhecimento

Para melhorar respostas, você pode:

1. **Adicionar nó de busca**: Antes do nó de IA, busque informações relevantes
2. **Integrar com KB**: Conecte com Knowledge Base do Zendesk
3. **Adicionar contexto de produto**: Inclua informações de produtos/serviços no prompt

Exemplo de adicionar busca de KB:

```javascript
// Nó Code antes do nó IA
const ticket = $('Buscar Informações do Ticket').item.json.ticket;
const searchQuery = $('Extrair Dados do Comentário').item.json.commentBody;

// Buscar artigos relevantes
const kbArticles = await $http.request({
  method: 'GET',
  url: `${$env.ZENDESK_BASE_URL}/api/v2/search.json`,
  headers: {
    'Authorization': `Basic ${$env.ZENDESK_AUTH_TOKEN}`
  },
  qs: {
    query: `type:article ${searchQuery}`,
    sort_by: 'relevance'
  }
});

return {
  json: {
    kbContext: kbArticles.results.slice(0, 3),
    ...$input.item.json
  }
};
```

### Ajustar Critérios de Escalação

Edite o nó **"IA: Classificar Escalação"** para personalizar quando escalar:

```markdown
Analise se a conversa precisa ser escalada para um agente humano. 
Considere:
- Complexidade técnica
- Frustração do cliente
- Solicitação explícita de falar com pessoa
- Problema não resolvido após 3+ tentativas
- Pedidos de cancelamento/reembolso
- Problemas críticos/sensíveis

Responda apenas: ESCALAR ou CONTINUAR
```

### Configurar Canais Específicos

No nó **"Zendesk: Novo Comentário/Chat"**, ajuste os filtros:

```json
{
  "event": "create",
  "filters": {
    "channels": ["web", "api", "chat", "mobile", "whatsapp", "email", "voicemail"]
  }
}
```

## 📊 Monitoramento e Métricas

### Logs de Execução

O nó **"Log: Execução"** registra:
- Timestamp
- Ticket ID
- Canal
- Mensagem (primeiros 100 caracteres)
- Resposta gerada (primeiros 100 caracteres)
- Se foi escalado

### Métricas Recomendadas

1. **Taxa de Resolução**: % de tickets resolvidos pelo bot
2. **Taxa de Escalação**: % de tickets escalados para humanos
3. **Tempo Médio de Resposta**: Tempo do bot responder
4. **Satisfação do Cliente**: Integrar com surveys do Zendesk
5. **Custo por Ticket**: Custos de API OpenAI por ticket

### Dashboard no n8n

Crie um dashboard simples:

1. Adicione nó **Code** para agregações
2. Use **Google Sheets** ou **Airtable** para armazenar métricas
3. Visualize com **Grafana** ou **Metabase**

## 🔧 Troubleshooting

### Problema: Webhook não está sendo disparado

**Solução**:
1. Verifique se o workflow está **ativado** no n8n
2. Confirme webhook no Zendesk está ativo
3. Teste webhook manualmente:
   ```bash
   curl -X POST [URL_WEBHOOK] \
     -H "Content-Type: application/json" \
     -d '{"test": "data"}'
   ```

### Problema: Bot respondendo a si mesmo (loop)

**Solução**:
1. Verifique `ZENDESK_AI_AGENT_ID` está correto
2. Confirme filtro no nó **"Filtrar: Comentário Válido"** está funcionando
3. Adicione verificação adicional:
   ```javascript
   // No nó "Filtrar: Comentário Válido"
   const authorId = $json.authorId;
   const botId = $env.ZENDESK_AI_AGENT_ID;
   
   if (authorId === botId) {
     return null; // Parar execução
   }
   ```

### Problema: IA não mantém contexto

**Solução**:
1. Verifique histórico está sendo carregado corretamente
2. Aumente número de mensagens no histórico (atualmente 10)
3. Adicione mais contexto no prompt

### Problema: Respostas muito lentas

**Solução**:
1. Use **GPT-3.5-turbo** em vez de GPT-4 (mais rápido, mais barato)
2. Reduza `maxTokens` no nó de IA
3. Cache histórico de conversas
4. Otimize chamadas HTTP ao Zendesk

### Problema: Custos OpenAI altos

**Solução**:
1. Mude para **GPT-3.5-turbo** (90% mais barato)
2. Reduza `maxTokens`
3. Implemente cache de respostas similares
4. Limite histórico de conversa

## 🔒 Segurança e Boas Práticas

### 1. Proteção de Dados

- ✅ Use variáveis de ambiente para credenciais
- ✅ Não exponha API keys no código
- ✅ Criptografe dados sensíveis
- ✅ Siga LGPD/GDPR

### 2. Rate Limiting

Adicione rate limiting para evitar abuso:

```javascript
// Nó Code antes do processamento
const ticketId = $json.ticketId;
const lastExecution = $getWorkflowStaticData('global').lastExecution || {};

if (lastExecution.ticketId === ticketId && 
    Date.now() - lastExecution.timestamp < 5000) {
  // Muito rápido, ignorar
  return null;
}

$getWorkflowStaticData('global').lastExecution = {
  ticketId,
  timestamp: Date.now()
};

return $input.all();
```

### 3. Validação de Entrada

Sempre valide dados antes de processar:

```javascript
const commentBody = $json.commentBody;

if (!commentBody || commentBody.trim().length === 0) {
  return null; // Ignorar comentários vazios
}

if (commentBody.length > 5000) {
  return null; // Ignorar mensagens muito longas
}
```

## 📈 Melhorias Futuras

- [ ] Integração com Knowledge Base do Zendesk
- [ ] Suporte a múltiplos idiomas
- [ ] Análise de sentimento para detectar frustração
- [ ] Cache de respostas para perguntas frequentes
- [ ] Integração com CRM para dados do cliente
- [ ] Métricas avançadas e dashboards
- [ ] Treinamento customizado com fine-tuning
- [ ] Suporte a mídia (imagens, documentos)

## 🆘 Suporte

Para dúvidas ou problemas:
1. Verifique logs do n8n
2. Revise documentação do Zendesk API
3. Consulte documentação do OpenAI
4. Verifique configurações de credenciais

---

**Versão**: 1.0  
**Última atualização**: 2024  
**Compatibilidade**: n8n 1.0+, Zendesk API v2, OpenAI GPT-4/GPT-3.5
