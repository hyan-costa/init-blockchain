#!/bin/bash
set -e

until [ -f "/app/config/Node-1/data/enode" ] && [ -f "/app/config/Node-2/data/enode" ]; do
  echo "Node 3 aguardando os enodes dos nós 1 e 2..."
  sleep 2
done

ENODE_1=$(< /app/config/Node-1/data/enode)
ENODE_2=$(< /app/config/Node-2/data/enode)
BOOTNODES="${ENODE_1},${ENODE_2}"

echo "Node 3 usando bootnodes: ${BOOTNODES}"

exec besu \
  --data-path=/app/config/Node-3/data \
  --genesis-file=/app/config/genesis.json \
  --host-allowlist="*" \
  --p2p-port=30305 \
  --bootnodes="$BOOTNODES" \
  --profile=ENTERPRISE \
  --miner-enabled \
  --miner-coinbase=0x627306090abaB3A6e1400e9345bC60c78a8BEf57 \
  --metrics-enabled \
  --metrics-host=0.0.0.0 \
  --metrics-port=9545 \
  --logging=INFO \
  --min-gas-price=0 \
  --rpc-http-enabled \
  --rpc-http-host=0.0.0.0 \
  --rpc-http-port=8545 \
  --data-storage-format=BONSAI \
  --bonsai-historical-block-limit=512 \
  --bonsai-trie-logs-pruning-window-size=5000