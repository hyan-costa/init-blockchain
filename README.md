# blockchain-besu

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

Com a configuração pronta, este comando inicia os 3 nós da rede Besu em modo detached (background).

```bash
  docker compose --profile nodes up -d
```


**Porta da rede blockchain:**
A porta principal para interagir com o Nó 1 via RPC é: 8545. Verifique os logs dos nós para confirmar a conexão entre os nós. Após alguns segundos, você verá que os nós começarão a minerar blocos.

O resultado final é uma rede em malha (mesh network), onde cada nó está conectado diretamente a todos os outros nós. 


## Testando a rede:

### Verifique a Conexão entre os Nós

Execute o comando abaixo, substituindo <IP> pelo IP da sua máquina ou localhost.


```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://<IP>:8545
```


Se a resposta for como a do json abaixo, os nós estão conectados.

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x3"
}
```

### Verifique a Produção de Blocos
Use o método eth_blockNumber para verificar se a rede está produzindo blocos.

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://<IP>:8545
```

Se o número de blocos (result) estiver aumentando a cada nova requisição, a rede está funcionando corretamente.

Exemplo de primeira requisição:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x987"
}
```

Exemplo de próxima requisição:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x9a2"
}
```
