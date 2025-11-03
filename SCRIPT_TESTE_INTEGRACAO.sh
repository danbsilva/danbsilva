#!/bin/bash

# Script de Teste de Integração - Zendesk + n8n + WhatsApp
# Use este script para validar se tudo está configurado corretamente

echo "🔍 Teste de Integração - Zendesk + n8n + WhatsApp"
echo "================================================="
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variáveis (configure aqui)
ZENDESK_SUBDOMAIN="${ZENDESK_SUBDOMAIN:-sua-empresa}"
ZENDESK_EMAIL="${ZENDESK_EMAIL:-seu-email@exemplo.com}"
ZENDESK_TOKEN="${ZENDESK_TOKEN:-seu-token}"
N8N_WEBHOOK_URL="${N8N_WEBHOOK_URL:-https://seu-n8n.exemplo.com}"
OPENAI_API_KEY="${OPENAI_API_KEY:-sk-...}"

echo "📋 Configurações:"
echo "   Zendesk: $ZENDESK_SUBDOMAIN.zendesk.com"
echo "   Email: $ZENDESK_EMAIL"
echo "   n8n Webhook: $N8N_WEBHOOK_URL"
echo ""

# Teste 1: Conectividade com Zendesk
echo "🧪 Teste 1: Conectividade com Zendesk API..."
ZENDESK_AUTH=$(echo -n "$ZENDESK_EMAIL/token:$ZENDESK_TOKEN" | base64)

if curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: Basic $ZENDESK_AUTH" \
  "https://$ZENDESK_SUBDOMAIN.zendesk.com/api/v2/users/me.json" | grep -q "200"; then
  echo -e "${GREEN}✅ Zendesk API acessível${NC}"
else
  echo -e "${RED}❌ Erro ao conectar com Zendesk API${NC}"
  echo "   Verifique: subdomain, email e token"
  exit 1
fi

# Teste 2: Webhook do n8n
echo ""
echo "🧪 Teste 2: Webhook do n8n..."
WEBHOOK_URL="$N8N_WEBHOOK_URL/webhook/zendesk-new-comment"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}')

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "404" ]; then
  echo -e "${GREEN}✅ Webhook do n8n acessível (HTTP $HTTP_CODE)${NC}"
else
  echo -e "${YELLOW}⚠️  Webhook retornou HTTP $HTTP_CODE${NC}"
  echo "   (Pode ser normal se webhook não existe ainda)"
fi

# Teste 3: OpenAI API
echo ""
echo "🧪 Teste 3: OpenAI API..."
if [ -z "$OPENAI_API_KEY" ] || [ "$OPENAI_API_KEY" = "sk-..." ]; then
  echo -e "${YELLOW}⚠️  OpenAI API Key não configurada${NC}"
else
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    "https://api.openai.com/v1/models")
  
  if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ OpenAI API acessível${NC}"
  else
    echo -e "${RED}❌ Erro ao conectar com OpenAI API (HTTP $HTTP_CODE)${NC}"
  fi
fi

# Teste 4: Verificar usuário bot no Zendesk
echo ""
echo "🧪 Teste 4: Verificar configuração..."
echo -e "${YELLOW}⚠️  Configure manualmente:${NC}"
echo "   1. ZENDESK_AI_AGENT_ID no n8n"
echo "   2. ZENDESK_HUMAN_AGENT_GROUP_ID no n8n"
echo "   3. Credenciais configuradas no n8n"
echo "   4. Workflow ativado no n8n"

# Teste 5: Checklist
echo ""
echo "📝 Checklist Manual:"
echo "   [ ] Zendesk API Token gerado"
echo "   [ ] Credenciais configuradas no n8n"
echo "   [ ] Variáveis de ambiente configuradas"
echo "   [ ] Workflow importado no n8n"
echo "   [ ] Workflow ativado"
echo "   [ ] Webhook criado automaticamente"
echo "   [ ] WhatsApp conectado no Zendesk"
echo "   [ ] Teste realizado com sucesso"

echo ""
echo -e "${GREEN}✅ Testes básicos concluídos!${NC}"
echo ""
echo "Próximos passos:"
echo "  1. Configure IDs no n8n"
echo "  2. Ative o workflow"
echo "  3. Teste criando um ticket"
echo ""
