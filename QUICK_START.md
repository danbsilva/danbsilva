# 🚀 Guia Rápido - Agente IA Zendesk

## ⚡ Início Rápido (5 minutos)

### 1. Importar Workflow (1 min)
```
n8n → Workflows → Import from File → n8n-agente-ia-zendesk.json
```

### 2. Configurar Credenciais (2 min)

#### Zendesk API
- Subdomain: `sua-empresa`
- Email: `seu-email@exemplo.com`
- Token: [Zendesk → Admin → APIs → Token]

#### OpenAI API
- API Key: [https://platform.openai.com/api-keys]

#### Zendesk HTTP Auth
```
Header: Authorization
Value: Basic [BASE64(email/token:apiToken)]
```

### 3. Variáveis de Ambiente (1 min)
```
ZENDESK_AI_AGENT_ID=123456789
ZENDESK_BASE_URL=https://sua-empresa.zendesk.com
ZENDESK_HUMAN_AGENT_GROUP_ID=987654321
```

### 4. Obter IDs (1 min)

**ID Agente IA:**
1. Zendesk → Admin → Team → Criar usuário "LIA Bot"
2. Copiar User ID da URL

**ID Grupo Humano:**
1. Zendesk → Admin → Team → Groups
2. Copiar Group ID

### 5. Ativar e Testar (30 seg)
1. Ativar workflow no n8n
2. Criar ticket de teste no Zendesk
3. Ver resposta automática em alguns segundos! ✅

## ✅ Checklist de Configuração

- [ ] Workflow importado
- [ ] Credencial Zendesk API configurada
- [ ] Credencial OpenAI API configurada
- [ ] Credencial Zendesk HTTP Auth configurada
- [ ] Variável `ZENDESK_AI_AGENT_ID` configurada
- [ ] Variável `ZENDESK_BASE_URL` configurada
- [ ] Variável `ZENDESK_HUMAN_AGENT_GROUP_ID` configurada
- [ ] Workflow ativado
- [ ] Teste realizado com sucesso

## 🧪 Como Testar

1. **Criar ticket no Zendesk:**
   - Via chat: `https://sua-empresa.zendesk.com`
   - Via email: Envie para seu email de suporte
   - Via WhatsApp: Se configurado

2. **Escrever mensagem de teste:**
   ```
   Olá, preciso de ajuda com meu pedido
   ```

3. **Aguardar resposta:**
   - O bot deve responder em 5-15 segundos
   - Resposta aparecerá como comentário público

4. **Testar escalação:**
   ```
   Preciso falar com um atendente humano
   ```
   - Bot deve escalar para grupo humano

## 🔍 Verificar se Está Funcionando

### No n8n:
- Execuções aparecem em **Executions**
- Status deve ser **Success** (verde)
- Clique na execução para ver detalhes

### No Zendesk:
- Ticket deve ter comentário do bot
- Comentário deve ser público
- Autor deve ser o usuário configurado como bot

### Problemas Comuns:

**❌ Erro: "Invalid credentials"**
→ Verifique credenciais do Zendesk/OpenAI

**❌ Erro: "Workflow not activated"**
→ Ative o workflow no n8n

**❌ Bot não responde**
→ Verifique webhook do Zendesk está configurado

**❌ Loop infinito**
→ Verifique `ZENDESK_AI_AGENT_ID` está correto

## 📞 Próximos Passos

1. Personalizar prompt do bot (nó "IA: Gerar Resposta")
2. Ajustar critérios de escalação
3. Configurar canais específicos
4. Adicionar integrações (CRM, KB, etc.)

Para mais detalhes, veja: `DOCUMENTACAO_AGENTE_IA_ZENDESK.md`
