# 🔗 Guia Completo de Integração: Zendesk + WhatsApp + n8n

## 📋 Visão Geral

Este guia explica como integrar **Zendesk**, **WhatsApp** e **n8n** para criar um sistema completo de atendimento automatizado com Agente IA.

## 🏗️ Arquitetura da Integração

```
Cliente WhatsApp
    ↓
Zendesk (Sunshine Conversations / WhatsApp Business API)
    ↓
Zendesk Webhooks
    ↓
n8n (Agente IA)
    ↓
Zendesk API (Enviar Resposta)
    ↓
Cliente WhatsApp
```

---

## 📦 Parte 1: Configuração do Zendesk

### 1.1. Configurar WhatsApp no Zendesk

#### Opção A: Zendesk Sunshine Conversations (Recomendado)

1. **Acesse o Zendesk Admin**
   ```
   Admin → Channels → Messaging and social → WhatsApp
   ```

2. **Conectar WhatsApp Business API**
   - Você precisará de uma conta **WhatsApp Business API** (via Twilio, MessageBird, ou Meta diretamente)
   - Ou usar **Zendesk Sunshine Conversations**

3. **Configurar Sunshine Conversations**
   ```
   Admin → Apps and integrations → APIs → Sunshine Conversations
   ```
   - Ative Sunshine Conversations
   - Configure seu provedor WhatsApp (Twilio, MessageBird, etc.)

#### Opção B: WhatsApp via Integrações Terceiras

1. **Usar Apps de Marketplace**
   - Instale app "WhatsApp Business" do Zendesk Marketplace
   - Siga instruções do app

2. **Configuração Manual via API**
   - Use webhooks customizados
   - Veja seção de Webhooks abaixo

### 1.2. Verificar Configuração de Webhooks

1. **Acesse Webhooks no Zendesk**
   ```
   Admin → Apps and integrations → Webhooks
   ```

2. **Criar Webhook Manual (Se necessário)**
   - URL: `https://seu-n8n.com/webhook/zendesk-new-comment`
   - Método: POST
   - Formato: JSON

3. **Verificar Triggers**
   ```
   Admin → Business rules → Triggers
   ```
   - Certifique-se que há triggers para comentários/tickets
   - O n8n trigger cria automaticamente, mas verifique

---

## 🔧 Parte 2: Configuração do n8n

### 2.1. Obter URL Pública do n8n

#### Se n8n está local (desenvolvimento):

Use **ngrok** ou similar para criar URL pública:

```bash
# Instalar ngrok
brew install ngrok  # Mac
# ou baixar de https://ngrok.com

# Criar tunnel
ngrok http 5678

# Copiar URL (ex: https://abc123.ngrok.io)
```

#### Se n8n está em servidor:

- Configure domínio apontando para seu n8n
- Configure SSL/HTTPS
- URL: `https://seu-n8n.exemplo.com`

### 2.2. Configurar Credenciais no n8n

#### Credencial 1: Zendesk API

1. **No n8n**: Credentials → Add Credential
2. **Tipo**: Zendesk API
3. **Preencha**:
   ```
   Subdomain: sua-empresa
   Email: seu-email@exemplo.com
   API Token: seu_token_api
   ```
4. **Salvar como**: "Zendesk API"

#### Obter API Token do Zendesk:

1. Zendesk → Admin → Apps and integrations → APIs → Zendesk API
2. Clique em "Add API token"
3. Copie o token gerado

#### Credencial 2: Zendesk HTTP Auth (para chamadas HTTP)

1. **Gerar Basic Auth**:
   ```bash
   # Use o script incluído
   ./scripts/gerar-basic-auth.sh seu-email@exemplo.com seu-token-api
   
   # Ou manualmente:
   echo -n "seu-email@exemplo.com/token:seu-token-api" | base64
   ```

2. **No n8n**: Credentials → Add Credential
3. **Tipo**: HTTP Header Auth
4. **Preencha**:
   ```
   Header Name: Authorization
   Header Value: Basic [código_base64_gerado]
   ```
5. **Salvar como**: "Zendesk HTTP Auth"

#### Credencial 3: OpenAI API

1. **No n8n**: Credentials → Add Credential
2. **Tipo**: OpenAI API
3. **Preencha**:
   ```
   API Key: sk-...
   ```
4. **Salvar como**: "OpenAI API"

### 2.3. Configurar Variáveis de Ambiente

No n8n: **Settings → Environment Variables**

```bash
# Zendesk - IDs e URLs
ZENDESK_AI_AGENT_ID=123456789
ZENDESK_BASE_URL=https://sua-empresa.zendesk.com
ZENDESK_HUMAN_AGENT_GROUP_ID=987654321

# Se usando versão modular, adicione IDs dos workflows:
MODULO_BUSCAR_CONTEXTO_WORKFLOW_ID=workflow_id_1
MODULO_CLASSIFICAR_INTENCAO_WORKFLOW_ID=workflow_id_2
MODULO_GERAR_RESPOSTA_WORKFLOW_ID=workflow_id_3
MODULO_ESCALACAO_WORKFLOW_ID=workflow_id_4

# OpenAI (opcional, padrões usados se não configurado)
OPENAI_MODEL=gpt-4
OPENAI_TEMPERATURE=0.7
OPENAI_MAX_TOKENS=2000
CONVERSATION_HISTORY_LIMIT=10
```

### 2.4. Obter IDs Necessários do Zendesk

#### ID do Agente IA (Bot):

1. **Criar usuário para o bot**:
   ```
   Admin → Team → Agents → Add agent
   ```
   - Nome: "LIA - Agente Virtual"
   - Email: `lia@sua-empresa.com` (ou email fictício)
   - Tipo: Agent
   - **Copiar User ID**

2. **Ou usar usuário existente**:
   - Abra o perfil do usuário
   - URL será: `https://sua-empresa.zendesk.com/agent/users/[USER_ID]`
   - Copie o `USER_ID`

#### ID do Grupo de Agentes Humanos:

1. **Criar ou usar grupo existente**:
   ```
   Admin → Team → Groups → Add group
   ```
   - Nome: "Atendimento Humano"
   - **Copiar Group ID**

2. **Ou obter ID de grupo existente**:
   - Abra o grupo
   - URL: `https://sua-empresa.zendesk.com/admin/groups/[GROUP_ID]`
   - Copie o `GROUP_ID`

---

## 🚀 Parte 3: Configurar Workflow no n8n

### 3.1. Importar Workflow

#### Opção A: Versão Monolítica (Recomendada para iniciantes)

1. **No n8n**: Workflows → Import from File
2. **Selecione**: `n8n-agente-ia-zendesk.json`
3. **Confirme importação**

#### Opção B: Versão Modular (Recomendada para produção)

1. **Importar módulos primeiro**:
   - `modulos/n8n-modulo-buscar-contexto.json`
   - `modulos/n8n-modulo-classificar-intencao.json`
   - `modulos/n8n-modulo-gerar-resposta.json`
   - `modulos/n8n-modulo-escalacao.json`
   - `modulos/n8n-modulo-knowledge-base.json` (opcional)

2. **Obter IDs dos workflows** (de cada módulo importado)

3. **Configurar variáveis** (como mostrado acima)

4. **Importar workflow principal**:
   - `n8n-agente-ia-modular.json`

### 3.2. Configurar Nós do Workflow

#### Nó: Zendesk Trigger

1. **Abra o workflow importado**
2. **Clique no nó "Zendesk: Novo Comentário"**
3. **Selecione credencial**: "Zendesk API"
4. **Verifique configuração**:
   - Event: `create`
   - Filtros de canais: `web, api, chat, mobile, whatsapp, email`
5. **Ativar Webhook**:
   - O n8n criará automaticamente um webhook
   - **Copie a URL do webhook** que aparece

#### Obter URL do Webhook:

Após ativar o workflow, a URL do webhook aparecerá. Formato:
```
https://seu-n8n.exemplo.com/webhook/zendesk-new-comment
```

### 3.3. Conectar Webhook do n8n ao Zendesk

#### Opção A: Usar Zendesk Trigger (Automático)

O n8n trigger do Zendesk se conecta automaticamente, mas você pode verificar:

1. **No n8n**: Veja o webhook criado
2. **No Zendesk**: Verifique se está recebendo eventos

#### Opção B: Configurar Manualmente

Se necessário, configure trigger no Zendesk:

1. **Zendesk**: Admin → Business rules → Triggers
2. **Criar novo trigger**:
   ```
   Nome: "Enviar para n8n - Novo Comentário"
   Condições:
     - Ticket: Is → Comment is → Public
     - Ticket: Is → Status → Open, New, Pending
   Ações:
     - Notify webhook
       URL: https://seu-n8n.exemplo.com/webhook/zendesk-new-comment
       Método: POST
       Content-Type: application/json
   ```

---

## ✅ Parte 4: Testar Integração

### 4.1. Teste Básico - Chat Web

1. **Criar ticket via chat web do Zendesk**:
   - Acesse: `https://sua-empresa.zendesk.com`
   - Inicie um chat
   - Envie: "Olá, preciso de ajuda"

2. **Verificar no n8n**:
   - Vá em **Executions**
   - Deve aparecer execução com status **Success** (verde)
   - Clique para ver detalhes

3. **Verificar no Zendesk**:
   - Ticket deve ter resposta do bot
   - Comentário público
   - Autor = usuário bot configurado

### 4.2. Teste WhatsApp

1. **Enviar mensagem via WhatsApp**:
   - Envie mensagem para número configurado no Zendesk
   - Exemplo: "Olá, preciso de ajuda"

2. **Verificar criação do ticket**:
   - No Zendesk, verifique se ticket foi criado
   - Canal deve aparecer como "WhatsApp"

3. **Verificar resposta**:
   - Bot deve responder via WhatsApp
   - Verifique no n8n Executions se processou

### 4.3. Teste de Escalação

1. **Enviar mensagem que precisa escalar**:
   ```
   "Preciso falar com um atendente humano"
   ```

2. **Verificar escalação**:
   - Ticket deve ser atribuído ao grupo humano
   - Nota interna deve ser adicionada
   - Prioridade deve mudar para "high"

---

## 🔍 Parte 5: Troubleshooting

### Problema: Webhook não recebe eventos

**Sintomas**: n8n não recebe eventos do Zendesk

**Soluções**:

1. **Verificar se workflow está ativado**:
   - Toggle "Active" no topo do workflow

2. **Verificar URL do webhook**:
   - Copie URL do webhook no n8n
   - Teste manualmente:
     ```bash
     curl -X POST https://seu-n8n.com/webhook/zendesk-new-comment \
       -H "Content-Type: application/json" \
       -d '{"test": "data"}'
     ```

3. **Verificar trigger no Zendesk**:
   - Admin → Business rules → Triggers
   - Confirme que trigger está ativo
   - Teste trigger manualmente

4. **Verificar firewall/SSL**:
   - n8n deve estar acessível publicamente
   - HTTPS funcionando
   - Porta não bloqueada

### Problema: Bot não responde

**Sintomas**: Webhook recebe, mas bot não responde

**Soluções**:

1. **Verificar logs no n8n**:
   - Executions → Abrir execução
   - Ver onde está falhando (nó com erro)

2. **Verificar credenciais**:
   - Teste credenciais Zendesk manualmente
   - Teste credenciais OpenAI

3. **Verificar variáveis de ambiente**:
   - Confirme todos os IDs estão corretos
   - `ZENDESK_AI_AGENT_ID` deve ser o ID do usuário bot

4. **Verificar filtros**:
   - Confirme filtro anti-loop está funcionando
   - Verifique se comentário é público

### Problema: Loop infinito

**Sintomas**: Bot responde a si mesmo repetidamente

**Soluções**:

1. **Verificar `ZENDESK_AI_AGENT_ID`**:
   ```bash
   # Deve ser o ID do usuário bot, não outro usuário
   ```

2. **Verificar nó de filtro**:
   - Nó "Filtrar: Comentário Válido"
   - Condição: `authorId !== ZENDESK_AI_AGENT_ID`

3. **Adicionar delay** (temporário):
   - Adicione nó "Wait" após envio de resposta
   - Delay: 5 segundos

### Problema: WhatsApp não aparece como canal

**Sintomas**: Mensagens WhatsApp não criam tickets ou não são processadas

**Soluções**:

1. **Verificar integração WhatsApp**:
   - Admin → Channels → WhatsApp
   - Confirme que está conectado e ativo

2. **Verificar filtros no workflow**:
   - Nó trigger: Adicione "whatsapp" aos canais filtrados
   - Já está incluído por padrão, mas verifique

3. **Verificar webhook do WhatsApp**:
   - Se usando integração terceira, verifique webhooks
   - Confirme que eventos chegam ao Zendesk

4. **Testar criação manual de ticket**:
   - Crie ticket manualmente via WhatsApp
   - Veja se workflow processa

---

## 📊 Parte 6: Monitoramento

### 6.1. Logs no n8n

1. **Executions**: Veja todas as execuções
2. **Filtros**: Por status, data, workflow
3. **Detalhes**: Clique para ver cada etapa

### 6.2. Métricas no Zendesk

1. **Reports**: Vá em Reports no Zendesk
2. **Criar dashboard**:
   - Tickets respondidos por bot
   - Tempo médio de resposta
   - Taxa de escalação

### 6.3. Alertas

Configure alertas no n8n para:
- Falhas de execução
- Tempo de resposta alto
- Erros de API

---

## 🔐 Parte 7: Segurança

### 7.1. Proteger Webhooks

1. **Usar autenticação**:
   - Configure webhook secret no n8n
   - Valide secret no código

2. **HTTPS obrigatório**:
   - Nunca use HTTP em produção
   - Configure SSL válido

3. **Rate Limiting**:
   - Configure limites no n8n
   - Proteja contra abuso

### 7.2. Proteger Credenciais

- ✅ Nunca commitar credenciais no código
- ✅ Usar variáveis de ambiente
- ✅ Rotacionar tokens periodicamente
- ✅ Usar permissões mínimas necessárias

---

## 🎯 Checklist Final

Antes de colocar em produção:

- [ ] Zendesk configurado e funcionando
- [ ] WhatsApp conectado e testado
- [ ] Webhooks funcionando
- [ ] Credenciais configuradas no n8n
- [ ] Variáveis de ambiente configuradas
- [ ] IDs do Zendesk obtidos e configurados
- [ ] Workflow importado e configurado
- [ ] Workflow ativado
- [ ] Teste via Chat Web funcionando
- [ ] Teste via WhatsApp funcionando
- [ ] Teste de escalação funcionando
- [ ] Logs sendo registrados
- [ ] Monitoramento configurado
- [ ] Equipe treinada

---

## 📚 Recursos Adicionais

### Documentação Oficial

- **Zendesk API**: https://developer.zendesk.com/api-reference
- **Zendesk Sunshine**: https://developer.zendesk.com/documentation/sunshine/
- **WhatsApp Business API**: https://developers.facebook.com/docs/whatsapp
- **n8n Docs**: https://docs.n8n.io

### Suporte

- **Zendesk Community**: https://support.zendesk.com
- **n8n Community**: https://community.n8n.io

---

**Versão**: 1.0  
**Última atualização**: 2024
