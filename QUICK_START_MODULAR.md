# ⚡ Guia Rápido - Arquitetura Modular

## 🎯 Instalação em 10 Minutos

### Passo 1: Importar Módulos (5 min)

Importe os módulos na ordem abaixo:

#### 1. Módulo: Buscar Contexto
```
n8n → Workflows → Import → modulos/n8n-modulo-buscar-contexto.json
```
- Nome: "Módulo: Buscar Contexto"
- **Copie o Workflow ID** (anote em algum lugar)

#### 2. Módulo: Classificar Intenção
```
n8n → Workflows → Import → modulos/n8n-modulo-classificar-intencao.json
```
- Nome: "Módulo: Classificar Intenção"
- **Copie o Workflow ID**

#### 3. Módulo: Gerar Resposta
```
n8n → Workflows → Import → modulos/n8n-modulo-gerar-resposta.json
```
- Nome: "Módulo: Gerar Resposta"
- **Copie o Workflow ID**

#### 4. Módulo: Escalação
```
n8n → Workflows → Import → modulos/n8n-modulo-escalacao.json
```
- Nome: "Módulo: Escalação Inteligente"
- **Copie o Workflow ID**

#### 5. Módulo: Knowledge Base (Opcional)
```
n8n → Workflows → Import → modulos/n8n-modulo-knowledge-base.json
```
- Nome: "Módulo: Buscar Knowledge Base"
- **Copie o Workflow ID**

### Passo 2: Obter IDs dos Workflows (2 min)

Para cada módulo importado:

1. Abra o workflow no n8n
2. Clique em "Settings" (⚙️) no canto superior direito
3. Copie o **Workflow ID** que aparece na URL ou nas configurações
4. Anote todos os IDs

**Formato da URL**: `https://seu-n8n.com/workflow/[WORKFLOW_ID]`

### Passo 3: Configurar Variáveis de Ambiente (2 min)

No n8n: **Settings** → **Environment Variables**

Adicione estas variáveis:

```bash
# IDs dos Módulos (OBRIGATÓRIO)
MODULO_BUSCAR_CONTEXTO_WORKFLOW_ID=seu_workflow_id_aqui
MODULO_CLASSIFICAR_INTENCAO_WORKFLOW_ID=seu_workflow_id_aqui
MODULO_GERAR_RESPOSTA_WORKFLOW_ID=seu_workflow_id_aqui
MODULO_ESCALACAO_WORKFLOW_ID=seu_workflow_id_aqui
MODULO_KB_WORKFLOW_ID=seu_workflow_id_aqui  # opcional

# Configurações Zendesk (já existentes)
ZENDESK_AI_AGENT_ID=123456789
ZENDESK_BASE_URL=https://sua-empresa.zendesk.com
ZENDESK_HUMAN_AGENT_GROUP_ID=987654321

# Configurações OpenAI (opcional, padrões)
OPENAI_MODEL=gpt-4
OPENAI_TEMPERATURE=0.7
OPENAI_MAX_TOKENS=2000
CONVERSATION_HISTORY_LIMIT=10
```

### Passo 4: Importar Workflow Principal (1 min)

```
n8n → Workflows → Import → n8n-agente-ia-modular.json
```

### Passo 5: Ativar Todos os Workflows (1 min)

**⚠️ IMPORTANTE**: Você deve ativar TODOS os workflows:

1. ✅ Módulo: Buscar Contexto → **Ativar**
2. ✅ Módulo: Classificar Intenção → **Ativar**
3. ✅ Módulo: Gerar Resposta → **Ativar**
4. ✅ Módulo: Escalação → **Ativar**
5. ✅ Módulo: Knowledge Base → **Ativar** (se importado)
6. ✅ Agente IA Zendesk - Modular (Principal) → **Ativar**

### Passo 6: Testar (1 min)

1. Crie um ticket de teste no Zendesk
2. Envie mensagem: "Olá, preciso de ajuda"
3. Aguarde resposta (10-20 segundos)
4. Verifique execuções no n8n

## ✅ Checklist Rápido

- [ ] Todos os 5 módulos importados
- [ ] IDs dos workflows copiados
- [ ] Variáveis de ambiente configuradas
- [ ] Workflow principal importado
- [ ] **TODOS os workflows ativados**
- [ ] Credenciais configuradas (Zendesk, OpenAI)
- [ ] Teste realizado com sucesso

## 🔍 Verificar se Está Funcionando

### No n8n:
1. Vá em **Executions**
2. Você deve ver execuções para:
   - Workflow principal
   - Cada módulo chamado
3. Status deve ser **Success** (verde)

### No Zendesk:
1. Ticket deve ter comentário do bot
2. Comentário público
3. Autor = usuário bot configurado

## 🐛 Problemas Comuns

### ❌ Erro: "Workflow not found"
**Solução**: 
- Verifique IDs nas variáveis de ambiente
- Confirme que workflows estão ativados
- IDs devem ser números, não nomes

### ❌ Erro: "Cannot execute workflow"
**Solução**:
- Confirme que módulos estão **ativados**
- Verifique permissões do usuário
- Todos os workflows devem estar na mesma instância do n8n

### ❌ Módulo não executa
**Solução**:
- Verifique se módulo está ativo
- Confirme workflow ID está correto
- Teste módulo individualmente (Execute Workflow)

### ❌ Dados não passam entre módulos
**Solução**:
- Verifique mapeamento no nó "Execute Workflow"
- Confirme formato de entrada do módulo
- Veja logs de execução para detalhes

## 📊 Estrutura Final

Após instalação, você terá:

```
n8n Workflows:
├── Agente IA Zendesk - Modular (Principal) ← ATIVAR
└── Módulos:
    ├── Módulo: Buscar Contexto ← ATIVAR
    ├── Módulo: Classificar Intenção ← ATIVAR
    ├── Módulo: Gerar Resposta ← ATIVAR
    ├── Módulo: Escalação ← ATIVAR
    └── Módulo: Knowledge Base ← ATIVAR (opcional)
```

## 🎯 Próximos Passos

1. ✅ Sistema funcionando
2. 📝 Personalizar prompts dos módulos
3. 🔧 Ajustar configurações
4. 📊 Configurar monitoramento
5. 🚀 Deploy em produção

Para mais detalhes, veja: `DOCUMENTACAO_ARQUITETURA_MODULAR.md`

---

**Tempo total**: ~10 minutos  
**Dificuldade**: ⭐⭐ Média  
**Requer**: IDs dos workflows + variáveis configuradas
