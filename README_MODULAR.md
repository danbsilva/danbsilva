# 🏗️ Agente IA Zendesk - Arquitetura Modular

> **Versão modularizada do Agente IA com componentes reutilizáveis e independentes**

## 🎯 Por Que Modular?

A arquitetura modular oferece:

✅ **Manutenibilidade**: Atualize módulos independentemente  
✅ **Reutilização**: Use módulos em outros workflows  
✅ **Testabilidade**: Teste cada módulo isoladamente  
✅ **Colaboração**: Equipe trabalha em módulos diferentes  
✅ **Escalabilidade**: Adicione/remova módulos facilmente  

## 📦 O Que Está Incluído

### Módulos Principais

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **Buscar Contexto** | `modulos/n8n-modulo-buscar-contexto.json` | Busca informações do ticket e histórico |
| **Classificar Intenção** | `modulos/n8n-modulo-classificar-intencao.json` | Classifica intenção da mensagem com IA |
| **Gerar Resposta** | `modulos/n8n-modulo-gerar-resposta.json` | Gera resposta contextual com IA |
| **Escalação** | `modulos/n8n-modulo-escalacao.json` | Decide e executa escalação para humanos |
| **Knowledge Base** | `modulos/n8n-modulo-knowledge-base.json` | Busca artigos relevantes (opcional) |

### Workflow Principal

| Arquivo | Descrição |
|---------|-----------|
| `n8n-agente-ia-modular.json` | Orquestra todos os módulos |

### Documentação

| Arquivo | Descrição |
|---------|-----------|
| `DOCUMENTACAO_ARQUITETURA_MODULAR.md` | Documentação completa da arquitetura |
| `QUICK_START_MODULAR.md` | Guia rápido de instalação |
| `README_MODULAR.md` | Este arquivo |

## 🚀 Instalação Rápida

### Opção 1: Guia Completo (Recomendado)
```bash
# Leia a documentação completa
cat DOCUMENTACAO_ARQUITETURA_MODULAR.md
```

### Opção 2: Início Rápido (10 minutos)
```bash
# Siga o guia rápido
cat QUICK_START_MODULAR.md
```

### Resumo em 3 Passos:

1. **Importar 5 módulos** no n8n
2. **Configurar IDs** nas variáveis de ambiente
3. **Importar e ativar** workflow principal

## 🏗️ Arquitetura

```
Workflow Principal (Orquestrador)
    │
    ├── Módulo: Buscar Contexto
    │   └── Busca ticket + histórico
    │
    ├── Módulo: Classificar Intenção
    │   └── Classifica mensagem do cliente
    │
    ├── Módulo: Knowledge Base (opcional)
    │   └── Busca artigos relevantes
    │
    ├── Módulo: Gerar Resposta
    │   └── Gera resposta com IA
    │
    └── Módulo: Escalação
        └── Decide se escala para humano
```

## 📋 Pré-requisitos

- ✅ n8n instalado
- ✅ Conta Zendesk com API
- ✅ OpenAI API Key
- ✅ Acesso administrativo

## 🔧 Configuração Mínima

### Variáveis de Ambiente Obrigatórias

```bash
# IDs dos Workflows (obtidos após importar módulos)
MODULO_BUSCAR_CONTEXTO_WORKFLOW_ID=workflow_id
MODULO_CLASSIFICAR_INTENCAO_WORKFLOW_ID=workflow_id
MODULO_GERAR_RESPOSTA_WORKFLOW_ID=workflow_id
MODULO_ESCALACAO_WORKFLOW_ID=workflow_id

# Zendesk
ZENDESK_AI_AGENT_ID=123456789
ZENDESK_BASE_URL=https://sua-empresa.zendesk.com
ZENDESK_HUMAN_AGENT_GROUP_ID=987654321
```

## 🔄 Fluxo de Execução

```
1. Cliente envia mensagem → Zendesk
2. Zendesk dispara webhook → n8n
3. Workflow Principal recebe evento
   ├── Executa: Buscar Contexto
   ├── Executa: Classificar Intenção (paralelo)
   ├── Executa: Buscar KB (paralelo, opcional)
   ├── Executa: Gerar Resposta
   └── Executa: Verificar Escalação (paralelo)
4. Envia resposta ou escala
5. Log da execução
```

## 🎓 Como Usar os Módulos

### Usar Módulo Individualmente

Você pode executar qualquer módulo independentemente:

```javascript
// Exemplo: Usar apenas classificação
const result = await executeWorkflow(
  MODULO_CLASSIFICAR_INTENCAO_WORKFLOW_ID,
  {
    message: "Preciso de ajuda",
    context: { ... }
  }
);

console.log(result.intent); // "INFO_GERAL"
```

### Adicionar Novo Módulo

1. Crie workflow do módulo
2. Importe no n8n
3. Obtenha workflow ID
4. Adicione variável `MODULO_NOVO_WORKFLOW_ID`
5. Adicione nó "Execute Workflow" no principal
6. Configure conexões

## 📊 Comparação: Monolítico vs Modular

| Aspecto | Monolítico | Modular |
|---------|-----------|---------|
| **Manutenção** | Difícil | Fácil |
| **Reutilização** | Limitada | Alta |
| **Testes** | Complexos | Simples |
| **Colaboração** | Conflitos | Isolado |
| **Escalabilidade** | Rígida | Flexível |
| **Debugging** | Difícil | Fácil |

## 🔍 Monitoramento

### Execuções por Módulo

No n8n, monitore:
- ✅ Execuções do workflow principal
- ✅ Execuções de cada módulo
- ✅ Tempo de execução por módulo
- ✅ Taxa de sucesso/erro

### Logs

Cada execução registra:
- Ticket ID
- Canal
- Intenção
- Escalado ou não
- Timestamp

## 🐛 Troubleshooting

### Módulo não executa
- ✅ Verifique se módulo está **ativado**
- ✅ Confirme workflow ID nas variáveis
- ✅ Teste módulo isoladamente

### Dados não passam
- ✅ Valide formato de entrada
- ✅ Verifique mapeamento no nó Execute Workflow
- ✅ Consulte logs de execução

## 📚 Documentação Detalhada

- **Guia Completo**: `DOCUMENTACAO_ARQUITETURA_MODULAR.md`
- **Início Rápido**: `QUICK_START_MODULAR.md`
- **Versão Monolítica**: `README_AGENTE_IA.md`

## 🎯 Vantagens da Versão Modular

✅ **Manutenção mais fácil**: Atualize um módulo sem afetar outros  
✅ **Reutilização**: Use módulos em outros projetos  
✅ **Testes isolados**: Teste cada módulo separadamente  
✅ **Colaboração**: Equipe trabalha em módulos diferentes  
✅ **Extensibilidade**: Adicione novos módulos facilmente  

## 🚀 Próximos Passos

1. ✅ Instalar módulos
2. ✅ Configurar variáveis
3. ✅ Testar sistema
4. 📝 Personalizar módulos
5. 📊 Configurar monitoramento
6. 🔄 Otimizar performance

---

**Versão**: 1.0 Modular  
**Compatibilidade**: n8n 1.0+  
**Status**: ✅ Pronto para produção

**Dúvidas?** Consulte `DOCUMENTACAO_ARQUITETURA_MODULAR.md`
