# ⚡ Guia Rápido - Cérebro do Agente

## 🎯 Em 5 Minutos

### 1. Importar Módulos (2 min)

```
n8n → Workflows → Import
```

Importe na ordem:
1. `n8n-cerebro-classificador.json`
2. `n8n-cerebro-gerador-resposta.json`
3. `n8n-cerebro-escalacao.json`
4. `n8n-cerebro-orquestrador.json` (opcional)

### 2. Configurar OpenAI (1 min)

```
n8n → Credentials → Add
Tipo: OpenAI API
API Key: sk-...
Nome: "OpenAI API"
```

### 3. Testar (2 min)

#### Teste Individual:
1. Abra "Cérebro: Classificador de Intenções"
2. Execute Workflow
3. Veja resultado

#### Teste Completo:
1. Obter IDs dos workflows importados
2. Configurar variáveis:
   ```bash
   CEREBRO_CLASSIFICADOR_WORKFLOW_ID=id_1
   CEREBRO_GERADOR_RESPOSTA_WORKFLOW_ID=id_2
   CEREBRO_ESCALACAO_WORKFLOW_ID=id_3
   ```
3. Executar "Cérebro: Orquestrador Completo"

---

## 📋 Exemplos de Teste

### Mensagem 1: Pedido de Status
```json
{
  "message": "Qual o status do meu pedido 12345?"
}
```
**Resultado esperado**: `intent: "PEDIDO_STATUS"`

### Mensagem 2: Escalação
```json
{
  "message": "Preciso falar com um atendente humano urgentemente"
}
```
**Resultado esperado**: `intent: "ESCALACAO"`, `escalated: true`

### Mensagem 3: Informação
```json
{
  "message": "Quais são os horários de atendimento?"
}
```
**Resultado esperado**: `intent: "INFO_GERAL"`

---

## ✅ Checklist

- [ ] Módulos importados
- [ ] Credencial OpenAI configurada
- [ ] Teste individual funcionando
- [ ] (Opcional) Orquestrador configurado
- [ ] (Opcional) Teste completo funcionando

---

**Pronto!** 🎉 Você tem o cérebro funcionando!

Para mais detalhes: `README_CEREBRO.md`
