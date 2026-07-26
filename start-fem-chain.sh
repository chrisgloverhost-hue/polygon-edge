#!/usr/bin/env bash
# Fem Chain — 4-validator IBFT devnet
# Node 1's JSON-RPC is exposed on :8080 (publicly reachable via Replit).

set -e

BINARY="./polygon-edge"
GENESIS="./genesis.json"
BOOTNODE="/ip4/127.0.0.1/tcp/30301/p2p/16Uiu2HAm4WSy6yu6nyHyqFoaYSSy2EGCb97BV81LV3dvPFozXvsb"

# Kill any previously running nodes
pkill -f "polygon-edge server" 2>/dev/null || true
sleep 1

echo "=============================="
echo "  Starting Fem Chain Devnet"
echo "  Chain ID : 23124"
echo "  Token    : FEM"
echo "  Consensus: IBFT (4 validators)"
echo "=============================="

# Node 1 — JSON-RPC on :8080 (public)
echo "[1/4] Starting validator 1 (JSON-RPC :8080)..."
$BINARY server \
  --data-dir ./fem-chain-1 \
  --chain $GENESIS \
  --grpc-address :10000 \
  --libp2p :30301 \
  --jsonrpc 0.0.0.0:8080 \
  --seal \
  --log-level INFO &
NODE1_PID=$!
echo "  PID: $NODE1_PID"

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
  --log-level WARN &
echo "  PID: $!"

# Node 3
echo "[3/4] Starting validator 3..."
$BINARY server \
  --data-dir ./fem-chain-3 \
  --chain $GENESIS \
  --grpc-address :10003 \
  --libp2p :30303 \
  --jsonrpc :10203 \
  --seal \
  --log-level WARN &
echo "  PID: $!"

# Node 4
echo "[4/4] Starting validator 4..."
$BINARY server \
  --data-dir ./fem-chain-4 \
  --chain $GENESIS \
  --grpc-address :10004 \
  --libp2p :30304 \
  --jsonrpc :10204 \
  --seal \
  --log-level WARN &
echo "  PID: $!"

echo ""
echo "=============================="
echo "  Fem Chain is LIVE!"
echo ""
echo "  JSON-RPC : http://0.0.0.0:8080"
echo "  Chain ID : 23124"
echo "  Symbol   : FEM"
echo ""
echo "  MetaMask settings:"
echo "    Network name : Fem"
echo "    RPC URL      : https://<your-replit-url>-8080.replit.dev"
echo "    Chain ID     : 23124"
echo "    Currency sym : FEM"
echo "=============================="

# Keep alive — wait for node 1
wait $NODE1_PID
