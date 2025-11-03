# ✅ Checklist de Configuração - Agente IA Zendesk

Use este checklist para garantir que tudo está configurado corretamente antes de ativar em produção.

## 📦 Fase 1: Preparação

### Zendesk
- [ ] Conta Zendesk ativa com acesso administrativo
- [ ] API habilitada no Zendesk
- [ ] Token de API gerado (Admin → Apps and integrations → APIs)
- [ ] Usuário do bot criado no Zendesk (ex: "LIA - Agente Virtual")
- [ ] User ID do bot anotado
- [ ] Grupo de agentes humanos identificado
- [ ] Group ID do grupo humano anotado

### OpenAI
- [ ] Conta OpenAI criada
- [ ] API Key gerada (https://platform.openai.com/api-keys)
- [ ] Créditos disponíveis na conta OpenAI
- [ ] Decidido qual modelo usar (GPT-4 ou GPT-3.5-turbo)

### n8n
- [ ] n8n instalado e acessível
- [ ] Acesso administrativo ao n8n
- [ ] Permissões para criar workflows e credenciais

## 🔧 Fase 2: Configuração no n8n

### Importar Workflow
- [ ] Workflow `n8n-agente-ia-zendesk.json` importado
- [ ] Todos os nós visíveis no editor
- [ ] Workflow salvo corretamente

### Configurar Credenciais
- [ ] **Credencial: Zendesk API**
  - [ ] Nome: "Zendesk API"
  - [ ] Subdomain preenchido
  - [ ] Email preenchido
  - [ ] API Token preenchido
  - [ ] Teste de conexão bem-sucedido

- [ ] **Credencial: Zendesk HTTP Auth**
  - [ ] Nome: "Zendesk HTTP Auth"
  - [ ] Tipo: HTTP Header Auth
  - [ ] Header Name: "Authorization"
  - [ ] Header Value: "Basic [base64]" gerado corretamente
  - [ ] Teste de conexão bem-sucedido

- [ ] **Credencial: OpenAI API**
  - [ ] Nome: "OpenAI API"
  - [ ] API Key preenchida
  - [ ] Teste de conexão bem-sucedido

### Configurar Variáveis de Ambiente
- [ ] `ZENDESK_AI_AGENT_ID` configurado (ID do usuário bot)
- [ ] `ZENDESK_BASE_URL` configurado (URL completa sem /api/v2)
- [ ] `ZENDESK_HUMAN_AGENT_GROUP_ID` configurado (ID do grupo humano)

### Validar Configurações dos Nós
- [ ] **Nó "Zendesk: Novo Comentário/Chat"**
  - [ ] Credencial Zendesk API selecionada
  - [ ] Evento: "create" configurado
  - [ ] Filtros de canais configurados (se necessário)

- [ ] **Nó "Extrair Dados do Comentário"**
  - [ ] Campos mapeados corretamente

- [ ] **Nó "Filtrar: Comentário Válido"**
  - [ ] Condição para isPublic = true
  - [ ] Condição para authorId ≠ bot ID

- [ ] **Nó "Buscar Informações do Ticket"**
  - [ ] URL configurada corretamente
  - [ ] Credencial HTTP Auth selecionada

- [ ] **Nó "Buscar Histórico da Conversa"**
  - [ ] URL configurada corretamente
  - [ ] Credencial HTTP Auth selecionada

- [ ] **Nó "IA: Gerar Resposta"**
  - [ ] Credencial OpenAI selecionada
  - [ ] Modelo configurado (gpt-4 ou gpt-3.5-turbo)
  - [ ] Prompt personalizado (se necessário)

- [ ] **Nó "Zendesk: Enviar Resposta IA"**
  - [ ] Credencial Zendesk API selecionada
  - [ ] authorId usando variável de ambiente

- [ ] **Nó "Zendesk: Escalar para Humano"**
  - [ ] Credencial Zendesk API selecionada
  - [ ] assigneeId usando variável de ambiente

## 🧪 Fase 3: Testes

### Teste Básico
- [ ] Criar ticket de teste no Zendesk
- [ ] Enviar mensagem de teste: "Olá, preciso de ajuda"
- [ ] Verificar execução no n8n (Executions)
- [ ] Verificar resposta do bot no Zendesk
- [ ] Resposta é pública
- [ ] Autor é o usuário bot

### Teste de Contexto
- [ ] Enviar primeira mensagem: "Olá"
- [ ] Bot responde
- [ ] Enviar segunda mensagem: "Qual é meu pedido?"
- [ ] Verificar se bot mantém contexto da conversa

### Teste de Escalação
- [ ] Enviar mensagem: "Preciso falar com um atendente humano"
- [ ] Verificar se ticket foi escalado
- [ ] Verificar se nota interna foi adicionada
- [ ] Verificar se ticket foi atribuído ao grupo humano

### Teste Anti-Loop
- [ ] Verificar que bot não responde a seus próprios comentários
- [ ] Verificar que bot não responde a comentários privados

### Teste Multi-canal (se aplicável)
- [ ] Testar via Chat do Zendesk
- [ ] Testar via Email
- [ ] Testar via WhatsApp (se configurado)

## 🔍 Fase 4: Validação Final

### Verificações de Segurança
- [ ] Credenciais não estão hardcoded no código
- [ ] Variáveis de ambiente configuradas corretamente
- [ ] Tokens não estão em logs públicos
- [ ] Acesso ao n8n é seguro

### Verificações de Performance
- [ ] Tempo de resposta do bot < 30 segundos
- [ ] Não há erros frequentes nos logs
- [ ] API do OpenAI respondendo corretamente
- [ ] API do Zendesk respondendo corretamente

### Verificações de Funcionalidade
- [ ] Todas as conexões entre nós estão corretas
- [ ] Filtros estão funcionando
- [ ] Escalação funciona quando necessário
- [ ] Logs estão sendo registrados

## 📊 Fase 5: Monitoramento

### Configurar Monitoramento
- [ ] Dashboard criado (opcional)
- [ ] Alertas configurados para erros
- [ ] Métricas definidas (taxa de resolução, escalação, etc.)
- [ ] Local para armazenar logs identificado

### Documentação Interna
- [ ] Documentação do workflow para equipe
- [ ] Processo de escalação documentado
- [ ] Contatos de suporte definidos

## 🚀 Fase 6: Ativação em Produção

### Preparação
- [ ] Backup do workflow criado
- [ ] Configurações de teste salvas separadamente
- [ ] Plano de rollback preparado
- [ ] Equipe treinada sobre o sistema

### Ativação
- [ ] Workflow ativado no n8n
- [ ] Primeiro ticket real monitorado de perto
- [ ] Validar primeiras respostas do bot
- [ ] Ajustar se necessário

### Pós-ativação
- [ ] Monitorar primeiras 24 horas
- [ ] Coletar feedback dos clientes
- [ ] Ajustar prompts se necessário
- [ ] Otimizar configurações

## ⚠️ Checklist de Problemas Comuns

Antes de pedir ajuda, verifique:

- [ ] Workflow está **ativado** no n8n?
- [ ] Webhook do Zendesk está **ativo**?
- [ ] Todos os IDs estão **corretos** (bot, grupo)?
- [ ] Credenciais foram **testadas** e funcionam?
- [ ] Variáveis de ambiente estão **definidas**?
- [ ] Logs do n8n foram **verificados**?
- [ ] API do OpenAI tem **créditos**?
- [ ] Conta Zendesk tem **permissões** corretas?

## 📝 Notas Adicionais

Use este espaço para anotar configurações específicas:

```
Zendesk Subdomain: _________________
Bot User ID: _________________
Grupo Humano ID: _________________
Modelo OpenAI: _________________
Data de Ativação: _________________
Responsável: _________________
```

---

**Status Final**: ⬜ Não Iniciado | ⬜ Em Progresso | ⬜ Completo | ⬜ Testado | ⬜ Produção

**Data de Conclusão**: _________________

**Assinatura**: _________________
