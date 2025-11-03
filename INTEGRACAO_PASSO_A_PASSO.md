# 🚀 Integração Passo a Passo - Zendesk + WhatsApp + n8n

## 📍 Visão Geral Rápida

```
1. Configurar Zendesk          → WhatsApp conectado
2. Configurar n8n              → Workflow importado
3. Conectar Zendesk + n8n      → Webhooks configurados
4. Testar                      → Tudo funcionando!
```

---

## ✅ Passo 1: Configurar WhatsApp no Zendesk (15 min)

### 1.1. Via Twilio (Recomendado para começar)

1. **Criar conta Twilio**:
   - Acesse: https://www.twilio.com
   - Crie conta gratuita (sandbox para testes)

2. **Ativar WhatsApp Sandbox**:
   ```
   Twilio Console → Messaging → Try it out → Send a WhatsApp message
   ```
   - Siga instruções para ativar sandbox
   - Anote: Account SID, Auth Token, Número WhatsApp

3. **No Zendesk**:
   ```
   Admin → Channels → Messaging and social → Messaging → Add channel
   ```
   - Selecione **WhatsApp**
   - Provider: **Twilio**
   - Preencha:
     - Account SID
     - Auth Token
     - WhatsApp Phone Number
   - **Salvar**

✅ **Resultado**: WhatsApp conectado ao Zendesk

**Mais detalhes**: Veja `CONFIGURAR_WHATSAPP_ZENDESK.md`

---

## ✅ Passo 2: Configurar n8n (10 min)

### 2.1. Obter URL Pública do n8n

**Se n8n está local**:
```bash
# Instalar ngrok
ngrok http 5678

# Copiar URL (ex: https://abc123.ngrok.io)
```

**Se n8n está em servidor**:
- Use sua URL pública (ex: `https://n8n.sua-empresa.com`)

### 2.2. Configurar Credenciais

#### Credencial 1: Zendesk API
```
n8n → Credentials → Add
Tipo: Zendesk API
Subdomain: sua-empresa
Email: seu-email@exemplo.com
API Token: [obter no Zendesk Admin → APIs]
```

#### Credencial 2: Zendesk HTTP Auth
```bash
# Gerar Basic Auth
./scripts/gerar-basic-auth.sh seu-email@exemplo.com seu-token

# No n8n:
Tipo: HTTP Header Auth
Header Name: Authorization
Header Value: Basic [código_gerado]
```

#### Credencial 3: OpenAI API
```
Tipo: OpenAI API
API Key: sk-... [de https://platform.openai.com/api-keys]
```

### 2.3. Configurar Variáveis de Ambiente

```
n8n → Settings → Environment Variables
```

Adicionar:
```bash
ZENDESK_AI_AGENT_ID=123456789
ZENDESK_BASE_URL=https://sua-empresa.zendesk.com
ZENDESK_HUMAN_AGENT_GROUP_ID=987654321
```

### 2.4. Obter IDs do Zendesk

**ID do Bot**:
```
Zendesk → Admin → Team → Agents → Add agent
Nome: "LIA - Agente Virtual"
Copiar User ID da URL
```

**ID do Grupo Humano**:
```
Zendesk → Admin → Team → Groups → Add group
Nome: "Atendimento Humano"
Copiar Group ID da URL
```

---

## ✅ Passo 3: Importar e Configurar Workflow (5 min)

### 3.1. Importar Workflow

**Opção Simples (Monolítica)**:
```
n8n → Workflows → Import from File
Selecione: n8n-agente-ia-zendesk.json
```

**Opção Avançada (Modular)**:
```
1. Importar módulos (modulos/*.json)
2. Obter IDs dos workflows
3. Configurar variáveis MODULO_*_WORKFLOW_ID
4. Importar n8n-agente-ia-modular.json
```

### 3.2. Configurar Nós

1. **Abrir workflow importado**

2. **Nó "Zendesk: Novo Comentário"**:
   - Selecionar credencial: "Zendesk API"
   - Verificar canais: `whatsapp, chat, email, web`

3. **Ativar Workflow**:
   - Toggle "Active" no topo
   - **Copiar URL do webhook** que aparece

✅ **Resultado**: Workflow configurado e webhook criado

---

## ✅ Passo 4: Conectar Tudo (5 min)

### 4.1. Verificar Webhook Automático

O n8n trigger cria webhook automaticamente. URL será algo como:
```
https://seu-n8n.exemplo.com/webhook/zendesk-new-comment
```

### 4.2. Configurar Trigger no Zendesk (Se necessário)

**Se webhook não for criado automaticamente**:

```
Zendesk → Admin → Business rules → Triggers → Create trigger
```

Nome: "Enviar para n8n"
Condições:
- Comment is public: Yes
- Status: Not solved

Ações:
- Notify webhook
- URL: [URL do webhook do n8n]
- Method: POST
- Content-Type: application/json

Salvar e ativar.

---

## ✅ Passo 5: Testar (5 min)

### Teste 1: Via Chat Web

1. **Acesse**: `https://sua-empresa.zendesk.com`
2. **Inicie chat**: "Olá, preciso de ajuda"
3. **Verificar**:
   - ✅ Execução no n8n (Executions)
   - ✅ Resposta do bot no chat
   - ✅ Status: Success

### Teste 2: Via WhatsApp

1. **Envie mensagem WhatsApp**:
   ```
   "Olá, preciso de ajuda"
   ```

2. **Verificar**:
   - ✅ Ticket criado no Zendesk
   - ✅ Canal: WhatsApp
   - ✅ Execução no n8n
   - ✅ Resposta via WhatsApp

### Teste 3: Escalação

1. **Envie**: "Preciso falar com um atendente humano"
2. **Verificar**:
   - ✅ Ticket escalado para grupo humano
   - ✅ Nota interna adicionada

---

## 🎯 Checklist Final

Antes de considerar completo:

- [ ] WhatsApp conectado no Zendesk e testado
- [ ] n8n acessível publicamente (HTTPS)
- [ ] Credenciais configuradas no n8n (3 credenciais)
- [ ] Variáveis de ambiente configuradas
- [ ] IDs do Zendesk obtidos e configurados
- [ ] Workflow importado e configurado
- [ ] Workflow ativado
- [ ] Webhook criado e testado
- [ ] Teste Chat Web funcionando
- [ ] Teste WhatsApp funcionando
- [ ] Teste escalação funcionando

---

## 🔍 Troubleshooting Rápido

### ❌ Bot não responde
1. Verificar workflow está **ativado**
2. Verificar execuções no n8n (há erros?)
3. Verificar credenciais estão corretas
4. Verificar IDs configurados corretamente

### ❌ Webhook não recebe eventos
1. Verificar URL do webhook está correta
2. Testar webhook manualmente (curl)
3. Verificar trigger no Zendesk está ativo

### ❌ WhatsApp não funciona
1. Verificar WhatsApp conectado no Zendesk
2. Testar envio manual de mensagem
3. Verificar logs do Twilio/MessageBird

**Mais detalhes**: Veja `GUIA_INTEGRACAO_COMPLETA.md`

---

## 📚 Documentação Completa

| Arquivo | Descrição |
|---------|-----------|
| `GUIA_INTEGRACAO_COMPLETA.md` | Guia completo e detalhado |
| `CONFIGURAR_WHATSAPP_ZENDESK.md` | Configuração detalhada do WhatsApp |
| `SCRIPT_TESTE_INTEGRACAO.sh` | Script de teste automatizado |

---

## ⏱️ Tempo Total

- **Configuração inicial**: ~45 minutos
- **Testes**: ~15 minutos
- **Total**: ~1 hora

---

**Pronto para começar!** 🚀

Siga os passos na ordem e você terá tudo funcionando em cerca de 1 hora.
