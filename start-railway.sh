#!/usr/bin/env bash
# Fem Chain — Railway deployment startup
# Railway injects $PORT; we bind node 1's JSON-RPC to it.

set -e

BINARY="./polygon-edge"
GENESIS="./genesis.json"
PORT="${PORT:-8080}"

# Kill any stale processes
pkill -f "polygon-edge server" 2>/dev/null || true
sleep 1

echo "=============================="
echo "  Fem Chain — Railway Deploy"
echo "  Chain ID : 23124"
echo "  Token    : FEM"
echo "  JSON-RPC : 0.0.0.0:$PORT"
echo "  Gas Price: 1 gwei minimum"
echo "=============================="

# Node 1 — JSON-RPC on $PORT (the only public port on Railway)
echo "[1/4] Starting validator 1 (JSON-RPC :$PORT)..."
$BINARY server \
  --data-dir ./fem-chain-1 \
  --chain $GENESIS \
  --grpc-address :10000 \
  --libp2p :30301 \
  --jsonrpc "0.0.0.0:$PORT" \
  --seal \
  --price-limit 1000000000 \
  --log-level INFO &
NODE1_PID=$!

sleep 3

# Node 2
echo "[2/4] Starting validator 2..."
$BINARY server \
  --data-dir ./fem-chain-2 \
  --chain $GENESIS \
  --grpc-address :10002 \
  --libp2p :30302 \
  --jsonrpc :10202 \
  --seal \
  --price-limit 1000000000 \
  --log-level WARN &

# Node 3
echo "[3/4] Starting validator 3..."
$BINARY server \
  --data-dir ./fem-chain-3 \
  --chain $GENESIS \
  --grpc-address :10003 \
  --libp2p :30303 \
  --jsonrpc :10203 \
  --seal \
  --price-limit 1000000000 \
  --log-level WARN &

# Node 4
echo "[4/4] Starting validator 4..."
$BINARY server \
  --data-dir ./fem-chain-4 \
  --chain $GENESIS \
  --grpc-address :10004 \
  --libp2p :30304 \
  --jsonrpc :10204 \
  --seal \
  --price-limit 1000000000 \
  --log-level WARN &

echo ""
echo "  Fem Chain is LIVE on port $PORT"
echo "=============================="

wait $NODE1_PID
