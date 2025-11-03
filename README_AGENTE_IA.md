# 🤖 Agente de IA para Zendesk - Sistema Completo

> **Sistema completo de Agente de IA conversacional integrado ao Zendesk para atendimento via WhatsApp, Chat e Email.**

## 📦 O que você recebe

Este pacote contém tudo que você precisa para criar um agente de IA profissional no Zendesk:

✅ **Workflow n8n completo** (`n8n-agente-ia-zendesk.json`)  
✅ **Documentação detalhada** (`DOCUMENTACAO_AGENTE_IA_ZENDESK.md`)  
✅ **Guia rápido de início** (`QUICK_START.md`)  
✅ **Arquivo de configuração exemplo** (`config-exemplo.env`)  
✅ **Scripts auxiliares** (`scripts/gerar-basic-auth.sh`)

## 🎯 Funcionalidades

### ✨ Principais Recursos

- 🤖 **Agente IA Conversacional**: Responde naturalmente usando GPT-4
- 💬 **Multi-canal**: Atende WhatsApp, Chat, Email e Web
- 🧠 **Memória Contextual**: Mantém histórico da conversa
- 🔄 **Escalação Inteligente**: Transfere para humanos quando necessário
- 📊 **Logging Completo**: Registra todas as interações
- ⚡ **Respostas Rápidas**: Tempo de resposta em segundos

### 🔧 Recursos Técnicos

- Integração nativa com Zendesk API
- Webhook automático para novos comentários
- Filtro anti-loop (não responde a si mesmo)
- Contexto de conversa (últimas 10 mensagens)
- Classificação inteligente de escalação
- Notas internas automáticas ao escalar

## 🚀 Começando Rápido

### Opção 1: Guia Rápido (5 minutos)
```bash
# Veja o guia rápido
cat QUICK_START.md
```

### Opção 2: Documentação Completa
```bash
# Documentação completa
cat DOCUMENTACAO_AGENTE_IA_ZENDESK.md
```

### Opção 3: Passo a Passo

1. **Importar workflow**
   - n8n → Workflows → Import from File
   - Selecione `n8n-agente-ia-zendesk.json`

2. **Configurar credenciais**
   - Zendesk API
   - OpenAI API
   - Zendesk HTTP Auth

3. **Configurar variáveis de ambiente**
   ```bash
   ZENDESK_AI_AGENT_ID=123456789
   ZENDESK_BASE_URL=https://sua-empresa.zendesk.com
   ZENDESK_HUMAN_AGENT_GROUP_ID=987654321
   ```

4. **Ativar e testar**
   - Ative o workflow no n8n
   - Crie um ticket de teste no Zendesk
   - Veja a mágica acontecer! ✨

## 📁 Estrutura de Arquivos

```
.
├── n8n-agente-ia-zendesk.json          # Workflow principal
├── DOCUMENTACAO_AGENTE_IA_ZENDESK.md   # Documentação completa
├── QUICK_START.md                      # Guia rápido
├── config-exemplo.env                  # Exemplo de configuração
├── README_AGENTE_IA.md                 # Este arquivo
└── scripts/
    └── gerar-basic-auth.sh             # Script auxiliar
```

## 🏗️ Arquitetura

```
Cliente (WhatsApp/Chat/Email)
        ↓
    Zendesk
        ↓
   Webhook → n8n
        ↓
   Processamento
   ├── Filtro (validação)
   ├── Busca contexto
   ├── IA (GPT-4)
   └── Resposta/Escalação
        ↓
    Zendesk → Cliente
```

## 📋 Pré-requisitos

- ✅ n8n instalado (Cloud ou Self-hosted)
- ✅ Conta Zendesk com API habilitada
- ✅ OpenAI API Key (GPT-4 ou GPT-3.5-turbo)
- ✅ Acesso administrativo ao Zendesk

## 🔐 Segurança

- ✅ Credenciais protegidas via n8n credentials
- ✅ Variáveis de ambiente para configurações
- ✅ Validação de entrada e saída
- ✅ Filtros anti-loop e anti-spam
- ✅ Logs para auditoria

## 💰 Custos Estimados

### OpenAI GPT-4
- ~$0.03 por conversa curta
- ~$0.06 por conversa longa
- **Economia**: Use GPT-3.5-turbo (90% mais barato)

### Zendesk
- Sem custos adicionais
- Usa API nativa

### n8n
- Depende do plano (Cloud ou Self-hosted)

**Estimativa mensal**: $50-200 para 1000 conversas/mês (GPT-4)

## 🎓 Personalização

O workflow é altamente customizável:

- 📝 **Prompts**: Ajuste personalidade do bot
- 🔄 **Escalação**: Configure critérios de transferência
- 📚 **Conhecimento**: Integre Knowledge Base
- 🌍 **Idiomas**: Adicione suporte multi-idioma
- 📊 **Métricas**: Configure dashboards

Veja `DOCUMENTACAO_AGENTE_IA_ZENDESK.md` para detalhes.

## 🐛 Troubleshooting

### Problema: Bot não responde
- ✅ Verifique se workflow está ativado
- ✅ Confirme webhook do Zendesk
- ✅ Veja logs no n8n Executions

### Problema: Loop infinito
- ✅ Verifique `ZENDESK_AI_AGENT_ID` está correto
- ✅ Confirme filtro anti-loop está funcionando

### Problema: Erros de credenciais
- ✅ Revise todas as credenciais no n8n
- ✅ Teste APIs manualmente

Veja seção de Troubleshooting na documentação completa.

## 📊 Métricas e Monitoramento

Monitore o desempenho do agente:

- Taxa de resolução automática
- Taxa de escalação
- Tempo médio de resposta
- Satisfação do cliente
- Custos por ticket

## 🚀 Próximos Passos

1. ✅ Importar workflow
2. ✅ Configurar credenciais
3. ✅ Testar com tickets reais
4. 📝 Personalizar prompts
5. 📊 Configurar métricas
6. 🔄 Integrar Knowledge Base
7. 🌍 Adicionar multi-idioma

## 📚 Documentação Adicional

- **Guia Rápido**: `QUICK_START.md`
- **Documentação Completa**: `DOCUMENTACAO_AGENTE_IA_ZENDESK.md`
- **Configuração**: `config-exemplo.env`

## 🤝 Suporte

Para problemas ou dúvidas:
1. Revise a documentação completa
2. Verifique logs no n8n
3. Teste componentes individualmente
4. Consulte documentação oficial:
   - [Zendesk API](https://developer.zendesk.com/api-reference)
   - [OpenAI API](https://platform.openai.com/docs)
   - [n8n Docs](https://docs.n8n.io)

## 📝 Changelog

### v1.0 (2024)
- ✅ Versão inicial
- ✅ Suporte a WhatsApp, Chat, Email
- ✅ Integração com GPT-4
- ✅ Escalação inteligente
- ✅ Sistema de contexto/memória

## 📄 Licença

Este projeto é fornecido como está para uso interno.

---

**Criado com ❤️ para facilitar atendimento ao cliente**

*Se este projeto foi útil, considere dar uma ⭐!*
