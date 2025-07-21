#!/bin/bash
set -e

until [ -f "/app/config/Node-1/data/enode" ] && [ -f "/app/config/Node-3/data/enode" ]; do
  echo "Node 2 aguardando os enodes dos nós 1 e 3..."
  sleep 2
done

ENODE_1=$(< /app/config/Node-1/data/enode)
ENODE_3=$(< /app/config/Node-3/data/enode)
BOOTNODES="${ENODE_1},${ENODE_3}"

echo "Node 2 usando bootnodes: ${BOOTNODES}"

exec besu \
  --data-path=/app/config/Node-2/data \
  --genesis-file=/app/config/genesis.json \
  --host-allowlist="*" \
  --p2p-port=30304 \
  --bootnodes="$BOOTNODES" \
  --profile=ENTERPRISE \
  --miner-enabled \
  --miner-coinbase=0x627306090abaB3A6e1400e9345bC60c78a8BEf57 \
  --logging=INFO \
  --min-gas-price=0 \
  --rpc-http-enabled \
  --rpc-http-host=0.0.0.0 \
  --rpc-http-port=8545 \
  --data-storage-format=BONSAI \
  --bonsai-historical-block-limit=512 \
  --bonsai-trie-logs-pruning-window-size=5000