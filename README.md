# blockchain-besu


Este projeto fornece uma solução de Infraestrutura para implantar rapidamente uma rede de blockchain privada com 3 nós validadores, utilizando Hyperledger Besu e o algoritmo de consenso QBFT. Com apenas dois comandos, o ambiente é totalmente configurado e iniciado via Docker Compose, ideal para fins de desenvolvimento, teste e estudo.


## Requisitos

* Docker
* Docker Compose


## Como Executar a Rede

O processo é dividido em duas etapas para garantir que a configuração seja criada antes de iniciar os nós da blockchain.


### Passo 1: Gerar a Configuração da Rede

Este comando executa o container de setup (`besu-setup`), que irá gerar as chaves dos nós e o arquivo `genesis.json`. O container irá parar automaticamente após a conclusão.

```bash
  docker compose --profile setup up
```

### Passo 2: Iniciar os Nós da Blockchain

Com a configuração pronta, este comando inicia os 3 nós da rede Besu em modo background.

```bash
  docker compose --profile nodes up -d
```


**Estrutura dos nós e portas:**
As portas principais para interagir via RPC é: 8545, 8546 e 8547. Verifique os logs dos nós para confirmar a conexão entre os nós. Após alguns segundos, você verá que os nós começarão a minerar blocos.
O resultado final é uma rede em malha (mesh network), onde cada nó está conectado diretamente a todos os outros nós. 


A tabela abaixo resume o mapeamento de portas da sua máquina (Host) para os contêineres:

| Nó | Serviço | Porta Interna (Contêiner) | Porta Externa (Host) |
| :--- | :--- | :--- | :--- |
| **Nó 1** | RPC (HTTP) | `8545` | `8545` |
| | P2P (Discovery) | `30303` | `30303` |
| **Nó 2** | RPC (HTTP) | `8545` | `8546` |
| | P2P (Discovery) | `30304` | `30304` |
| **Nó 3** | RPC (HTTP) | `8545` | `8547` |
| | P2P (Discovery) | `30305` | `30305` |


## Testando a rede:

### Verifique a Conexão entre os Nós

Execute o comando abaixo.


```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://127.0.0.1:8545
```

Se a resposta for como a do json abaixo, significa que os três peers foram conectados.

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x3"
}
```

### Verifique a Produção de Blocos

Use o método `eth_blockNumber` para verificar se a rede está produzindo blocos. O número do bloco (o valor em `result`) deve ser o mesmo ou muito próximo em todos os nós e deve aumentar com o tempo.

**Para chamar o Nó 1 (RPC na porta 8545):**
```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://127.0.0.1:8545
```

**Para chamar o Nó 2 (RPC na porta 8546):**
```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://127.0.0.1:8546
```

**Para chamar o Nó 3 (RPC na porta 8547):**
```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://127.0.0.1:8547
```

Se o número de blocos (result) estiver aumentando a cada nova requisição, a rede está funcionando corretamente.

Exemplo da primeira requisição:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x987"
}
```

Exemplo da próxima requisição:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x9a2"
}
```
