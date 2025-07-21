#!/bin/bash

until [ -f "/app/config/Node-2/data/enode" ] && [ -f "/app/config/Node-3/data/enode" ]; do
  echo "Node 1 aguardando os enodes dos nós 2 e 3..."
  sleep 2
done


ENODE_2=$(< /app/config/Node-2/data/enode)
ENODE_3=$(< /app/config/Node-3/data/enode)
BOOTNODES="${ENODE_2},${ENODE_3}"

echo "Node 1 usando bootnodes: ${BOOTNODES}"

besu \
  --data-path=/app/config/Node-1/data \
  --genesis-file=/app/config/genesis.json \
  --rpc-http-api=ETH,NET,WEB3,QBFT,ADMIN,DEBUG,MINER,TXPOOL \
  --host-allowlist="*" \
  --profile=ENTERPRISE \
  --rpc-http-enabled \
  --bootnodes="$BOOTNODES" \
  --rpc-http-host=0.0.0.0 \
  --rpc-http-port=8545 \
  --p2p-port=30303 \
  --miner-enabled \
  --miner-coinbase=0x627306090abaB3A6e1400e9345bC60c78a8BEf57 \
  --metrics-enabled \
  --metrics-host=0.0.0.0 \
  --metrics-port=9545 \
  --logging=INFO \
  --min-gas-price=0 \
  --data-storage-format=BONSAI \
  --bonsai-historical-block-limit=512 \
  --bonsai-trie-logs-pruning-window-size=5000


