# 📱 Como Configurar WhatsApp no Zendesk

## 🎯 Opções de Integração

O Zendesk oferece várias formas de integrar WhatsApp:

### Opção 1: Zendesk Sunshine Conversations (Recomendado)

**Melhor para**: Empresas que querem integração nativa e fácil

#### Passo a Passo:

1. **Ativar Sunshine Conversations**
   ```
   Admin → Apps and integrations → APIs → Sunshine Conversations
   ```
   - Clique em "Enable"
   - Siga o assistente de configuração

2. **Conectar WhatsApp Business API**
   - Você precisa de uma conta **WhatsApp Business API**
   - Opções de provedor:
     - **Twilio** (recomendado para começar)
     - **MessageBird**
     - **Meta diretamente** (requer aprovação)

3. **Via Twilio** (Mais fácil):
   ```
   a. Crie conta em https://www.twilio.com
   b. Configure WhatsApp Sandbox ou WhatsApp Business API
   c. No Zendesk: Admin → Channels → Messaging → Add channel
   d. Selecione WhatsApp
   e. Conecte com Twilio usando credenciais
   ```

#### Configuração Twilio:

1. **Criar conta Twilio**
   - Acesse: https://www.twilio.com
   - Faça cadastro e verifique número de telefone

2. **Configurar WhatsApp Sandbox** (Teste):
   ```
   Console → Messaging → Try it out → Send a WhatsApp message
   ```
   - Siga instruções para ativar sandbox
   - Você receberá número temporário para testes

3. **Obter Credenciais**:
   - Account SID
   - Auth Token
   - WhatsApp Number (do sandbox ou Business API)

4. **Conectar no Zendesk**:
   ```
   Admin → Channels → Messaging → Add channel → WhatsApp
   Provider: Twilio
   Account SID: [seu_account_sid]
   Auth Token: [seu_auth_token]
   Phone Number: [seu_numero_whatsapp]
   ```

---

### Opção 2: App do Marketplace

**Melhor para**: Solução rápida sem desenvolvimento

1. **Acesse Zendesk Marketplace**
   ```
   Admin → Apps and integrations → Marketplace
   ```

2. **Busque "WhatsApp"**
   - Várias opções disponíveis
   - Leia reviews e escolha a melhor

3. **Instale e configure**
   - Siga instruções do app escolhido
   - Geralmente precisa de API keys

---

### Opção 3: Webhooks Customizados

**Melhor para**: Controle total e integração customizada

Se você já tem WhatsApp Business API configurado:

1. **Configurar Webhook no WhatsApp**:
   - No painel do WhatsApp Business API
   - Configure webhook URL para enviar eventos ao Zendesk

2. **Criar Tickets via API do Zendesk**:
   - Use Zendesk API para criar tickets quando receber mensagens
   - Configure triggers para respostas

**Exemplo de código** (Node.js):
```javascript
const axios = require('axios');

// Quando receber mensagem WhatsApp via webhook
async function createTicketFromWhatsApp(whatsappMessage) {
  const ticket = {
    ticket: {
      subject: `WhatsApp: ${whatsappMessage.from}`,
      comment: {
        body: whatsappMessage.text.body,
        public: true
      },
      via: {
        channel: "whatsapp"
      },
      requester: {
        name: whatsappMessage.profile.name,
        email: `${whatsappMessage.from}@whatsapp.local`
      }
    }
  };

  await axios.post(
    `https://${ZENDESK_SUBDOMAIN}.zendesk.com/api/v2/tickets.json`,
    ticket,
    {
      headers: {
        'Authorization': `Basic ${ZENDESK_AUTH}`,
        'Content-Type': 'application/json'
      }
    }
  );
}
```

---

## 🔧 Configuração Detalhada (Twilio + Zendesk)

### Passo 1: Twilio WhatsApp Sandbox (Teste)

1. **Acesse Twilio Console**:
   https://console.twilio.com

2. **Vá em Messaging → Try it out → Send a WhatsApp message**

3. **Ative Sandbox**:
   - Você receberá um código
   - Envie código via WhatsApp para número fornecido
   - Sandbox ativado!

4. **Anote informações**:
   - Account SID (começa com AC...)
   - Auth Token
   - WhatsApp Sandbox Number (começa com whatsapp:+)

### Passo 2: Configurar no Zendesk

1. **Admin → Channels → Messaging and social → Messaging**

2. **Add messaging channel → WhatsApp**

3. **Provider: Twilio**

4. **Preencha**:
   ```
   Account SID: ACxxxxxxxxxxxxx
   Auth Token: seu_auth_token
   WhatsApp Phone Number: whatsapp:+14155238886
   ```

5. **Teste conexão**

6. **Salvar e ativar**

### Passo 3: Testar

1. **Envie mensagem para número do sandbox**
2. **Verifique se ticket foi criado no Zendesk**
3. **Responda no Zendesk**
4. **Verifique se resposta chegou via WhatsApp**

---

## 📋 Configuração WhatsApp Business API Completa

Para produção, você precisa de WhatsApp Business API oficial:

### Requisitos:

1. **Conta Business Verificada**:
   - Business Manager no Facebook
   - Verificação aprovada

2. **Número de Telefone Business**:
   - Número dedicado
   - Não pode ser número pessoal usado no WhatsApp

3. **Aprovação da Meta**:
   - Aplicar para WhatsApp Business API
   - Pode levar alguns dias

### Processo:

1. **Facebook Business Manager**:
   ```
   https://business.facebook.com
   ```
   - Criar conta business
   - Verificar domínio
   - Conectar WhatsApp Business Account

2. **Configurar WhatsApp Business API**:
   - Escolher provedor (Twilio, MessageBird, etc.)
   - Configurar número
   - Aguardar aprovação

3. **Conectar no Zendesk**:
   - Usar credenciais do provedor
   - Seguir mesmo processo do sandbox

---

## ✅ Verificar se WhatsApp Está Funcionando

### Checklist:

- [ ] WhatsApp conectado no Zendesk
- [ ] Número verificado e ativo
- [ ] Webhook configurado (se necessário)
- [ ] Ticket criado quando recebe mensagem
- [ ] Resposta enviada via WhatsApp
- [ ] Canal aparece como "whatsapp" no ticket

### Teste Manual:

1. **Envie mensagem WhatsApp**:
   ```
   "Olá, preciso de ajuda"
   ```

2. **Verifique no Zendesk**:
   - Admin → Views → Open tickets
   - Procure ticket novo
   - Canal deve ser "WhatsApp"

3. **Responda no Zendesk**:
   - Escreva resposta
   - Envie como comentário público
   - Verifique se chegou via WhatsApp

---

## 🐛 Troubleshooting WhatsApp

### Problema: Mensagens não chegam ao Zendesk

**Soluções**:
- ✅ Verificar webhook do WhatsApp configurado
- ✅ Confirmar número do WhatsApp está correto
- ✅ Verificar se sandbox está ativo (teste)
- ✅ Confirmar credenciais do Twilio/MessageBird

### Problema: Respostas não chegam via WhatsApp

**Soluções**:
- ✅ Verificar configuração do canal no Zendesk
- ✅ Confirmar comentário é público
- ✅ Verificar logs do Twilio/MessageBird
- ✅ Testar envio manual via API

### Problema: WhatsApp não aparece como canal

**Soluções**:
- ✅ Verificar configuração do canal
- ✅ Confirmar mensagem veio via WhatsApp
- ✅ Verificar campo `via.channel` no ticket
- ✅ Ver logs do Zendesk

---

## 📚 Recursos

- **Twilio WhatsApp**: https://www.twilio.com/docs/whatsapp
- **MessageBird WhatsApp**: https://developers.messagebird.com/api
- **Meta WhatsApp Business API**: https://developers.facebook.com/docs/whatsapp
- **Zendesk Sunshine**: https://developer.zendesk.com/documentation/sunshine/

---

**Versão**: 1.0  
**Última atualização**: 2024
