# 📋 Documentação - Fluxo N8N: Agente de Suporte (Pós-Venda)

## 📖 Descrição

Este workflow do n8n automatiza o atendimento de suporte pós-venda, classificando intenções de tickets do Zendesk e roteando para diferentes ações:
- **JORNADA_PÓS_COMPRA**: Busca status do pedido e responde automaticamente
- **RETENÇÃO_CANCELAMENTO**: Transborda para fila humana com nota interna
- **NECESSITA_ESCLARECIMENTO**: Solicita CPF ao cliente

## 🔄 Estrutura do Fluxo

### Gatilhos
1. **Zendesk On Ticket Create** - Dispara quando um novo ticket é criado
2. **Zendesk On Ticket Update** - Dispara quando um ticket é atualizado

### Processamento
1. **Merge** - Une os dois gatilhos
2. **Set** - Extrai dados do ticket (ID, assunto, descrição, requester, etc.)
3. **IF (Trava de Segurança)** - Verifica se o ticket não foi criado pelo próprio bot para evitar loops
4. **HTTP Request** - Busca dados do cliente na API
5. **IA Classificação** - Classifica a intenção usando GPT-4
6. **Switch** - Roteia baseado na intenção classificada

### Caminhos de Execução

#### Caminho A: JORNADA_PÓS_COMPRA
1. Busca status do pedido na API
2. Gera resposta amigável usando IA
3. Publica resposta pública no Zendesk

#### Caminho B: RETENÇÃO_CANCELAMENTO
1. Gera nota interna usando IA
2. Transborda ticket para fila de retenção

#### Caminho C: NECESSITA_ESCLARECIMENTO
1. Solicita CPF ao cliente via comentário público

## 🚀 Como Importar

1. Abra o n8n
2. Clique em **Workflows** → **Import from File**
3. Selecione o arquivo `n8n-agente-suporte-pos-venda.json`
4. Configure as credenciais necessárias (veja seção abaixo)

## 🔐 Credenciais Necessárias

### 1. Zendesk API
- **Tipo**: Zendesk API
- **Campos necessários**:
  - Subdomain (ex: `sua-empresa`)
  - Email
  - API Token
- **Uso**: Gatilhos, envio de comentários, transbordo

### 2. OpenAI API
- **Tipo**: OpenAI API
- **Campos necessários**:
  - API Key
- **Uso**: Classificação de intenções, geração de respostas e notas internas

### 3. API Cliente (HTTP Header Auth)
- **Tipo**: HTTP Header Auth
- **Campos necessários**:
  - Name: `Authorization` (ou conforme sua API)
  - Value: `Bearer seu-token-aqui`
- **Uso**: Buscar dados do cliente

### 4. API Pedido (HTTP Header Auth)
- **Tipo**: HTTP Header Auth
- **Campos necessários**:
  - Name: `Authorization` (ou conforme sua API)
  - Value: `Bearer seu-token-aqui`
- **Uso**: Buscar status do pedido

## 🌍 Variáveis de Ambiente

Configure estas variáveis no n8n (Settings → Environment Variables):

```bash
# URLs das APIs
API_CLIENTE_URL=https://api.exemplo.com
API_PEDIDO_URL=https://api.exemplo.com

# IDs do Zendesk
ZENDESK_LIA_AUTHOR_ID=123456789  # ID do usuário "LIA" no Zendesk
ZENDESK_FILA_RETENCAO_ID=987654321  # ID da fila de retenção/cancelamento
```

## ⚙️ Configurações dos Nós

### Nó IF: Trava de Segurança
Este nó previne loops infinitos verificando se o autor do ticket é o próprio bot. 
**Ajuste necessário**: Configure a condição para comparar com o ID do autor do bot (LIA).

**Exemplo de condição corrigida**:
```
{{ $json.authorId }} !== {{ $env.ZENDESK_LIA_AUTHOR_ID }}
```

### Nó IA: Classificar Intenção (Prompt 1)
- **Model**: GPT-4
- **Temperature**: 0.3 (mais determinístico)
- **Max Tokens**: 500

**Prompt System**:
```
Você é um classificador de intenções para tickets de suporte pós-venda. 
Classifique a intenção do ticket em uma das seguintes categorias:
- JORNADA_PÓS_COMPRA: Cliente quer saber sobre status de pedido, rastreamento, entrega
- RETENÇÃO_CANCELAMENTO: Cliente quer cancelar pedido, reclamar, pedir reembolso
- NECESSITA_ESCLARECIMENTO: Precisa de mais informações do cliente (CPF, dados adicionais)

Responda APENAS com uma das três opções acima, sem explicações adicionais.
```

### Nó IA: Gerar Nota Interna (Prompt 2)
- **Model**: GPT-4
- **Temperature**: 0.5
- **Max Tokens**: 800

### Nó IA: Gerar Resposta de Status (Prompt 3)
- **Model**: GPT-4
- **Temperature**: 0.7 (mais criativo)
- **Max Tokens**: 1000

## 📝 Personalizações Recomendadas

### 1. Ajustar Trava de Segurança
O nó IF atual pode precisar de ajustes. Considere verificar múltiplas condições:
- Se o autor é o bot
- Se já foi processado anteriormente
- Se está em um status específico

### 2. Adicionar Tratamento de Erros
Considere adicionar nós de tratamento de erro após:
- HTTP Request (API Cliente)
- HTTP Request (API Pedido)
- Nós de IA

### 3. Adicionar Logging
Adicione nós de log para debug:
- Após classificação de intenção
- Após cada ação principal

### 4. Melhorar Mensagem de Solicitação de CPF
Personalize a mensagem no nó "Nó Zendesk: Pedir CPF" conforme seu tom de voz.

## 🧪 Testando o Fluxo

1. Ative o workflow no n8n
2. Crie um ticket de teste no Zendesk
3. Verifique se o fluxo é disparado
4. Confira os logs de execução no n8n
5. Verifique se a resposta foi postada corretamente no Zendesk

## 📊 Monitoramento

- Acompanhe as execuções em **Executions** no n8n
- Configure alertas para falhas recorrentes
- Monitore custos da API OpenAI (uso de GPT-4)

## ⚠️ Observações Importantes

1. **Custos**: O workflow usa GPT-4, que tem custos por requisição. Considere usar GPT-3.5-turbo para testes.

2. **Rate Limiting**: Configure rate limiting nas chamadas de API se necessário.

3. **Timeout**: Ajuste timeouts nos nós HTTP conforme necessário.

4. **Segurança**: Não exponha tokens e credenciais. Use variáveis de ambiente.

## 🔄 Próximos Passos

- [ ] Testar com tickets reais
- [ ] Ajustar prompts de IA baseado em resultados
- [ ] Configurar tratamento de erros
- [ ] Adicionar métricas e monitoramento
- [ ] Documentar casos de uso específicos

---

**Criado em**: 2024  
**Versão**: 1.0
