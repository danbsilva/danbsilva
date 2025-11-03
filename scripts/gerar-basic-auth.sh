#!/bin/bash

# Script para gerar Basic Auth para Zendesk HTTP Header Auth
# Uso: ./gerar-basic-auth.sh seu-email@exemplo.com seu-token-api

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "❌ Erro: Email e Token são necessários"
    echo ""
    echo "Uso: $0 <email> <api-token>"
    echo ""
    echo "Exemplo:"
    echo "  $0 suporte@exemplo.com abc123xyz"
    echo ""
    exit 1
fi

EMAIL="$1"
TOKEN="$2"

# Formato: email/token:apiToken
CREDENTIALS="${EMAIL}/token:${TOKEN}"

# Gerar Base64
BASE64_ENCODED=$(echo -n "$CREDENTIALS" | base64)

echo ""
echo "✅ Basic Auth gerado com sucesso!"
echo ""
echo "Configure no n8n:"
echo "  Tipo: HTTP Header Auth"
echo "  Header Name: Authorization"
echo "  Header Value: Basic $BASE64_ENCODED"
echo ""
echo "Ou use diretamente nas requisições:"
echo "  Authorization: Basic $BASE64_ENCODED"
echo ""
