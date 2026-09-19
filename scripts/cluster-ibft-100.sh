#!/usr/bin/env bash
# Fem Chain 100-validator IBFT TESTNET launcher.
#
# This script deliberately creates INSECURE, disposable local keys. It is only for
# load/finality testing and must never be used to create mainnet keys or genesis.

set -euo pipefail

if [[ "${FEM_TESTNET_CONFIRM:-}" != "YES" ]]; then
  echo "Refusing to run. This creates 100 disposable testnet validators."
  echo "Run: FEM_TESTNET_CONFIRM=YES ./scripts/cluster-ibft-100.sh"
  exit 2
fi

BINARY="${FEM_BINARY:-./polygon-edge}"
WORKDIR="${FEM_TESTNET_WORKDIR:-./.fem-testnet-100}"
VALIDATORS=100
CHAIN_ID=23124001

if [[ ! -x "$BINARY" ]]; then
  echo "Missing executable: $BINARY"
  echo "Build first: go build -o polygon-edge ."
  exit 1
fi

if [[ "$WORKDIR" != "./.fem-testnet-100" ]]; then
  echo "For safety this script only permits the default work directory."
  exit 2
fi

rm -rf ./\.fem-testnet-100
mkdir -p "$WORKDIR"

echo "Generating $VALIDATORS disposable IBFT testnet identities..."
"$BINARY" secrets init --insecure --data-dir "$WORKDIR/validator-" --num "$VALIDATORS"

bootnodes=()
for i in 1 2 3; do
  node_id=$("$BINARY" secrets output --data-dir "$WORKDIR/validator-$i" | awk '/Node/ { print $4; exit }')
  if [[ -z "$node_id" ]]; then
    echo "Could not read libp2p peer ID for validator $i"
    exit 1
  fi
  bootnodes+=(--bootnode "/ip4/127.0.0.1/tcp/$((31000 + i))/p2p/$node_id")
done

echo "Generating a disposable $VALIDATORS-validator genesis..."
"$BINARY" genesis \
  --name "Fem Chain 100 Validator Testnet" \
  --chain-id "$CHAIN_ID" \
  --consensus ibft \
  --ibft-validator-type bls \
  --validators-prefix "$WORKDIR/validator-" \
  --block-gas-limit 10000000 \
  --epoch-size 1000 \
  --premine "0x0000000000000000000000000000000000000001:1000000000000000000000000000" \
  --dir "$WORKDIR/genesis.json" \
  "${bootnodes[@]}"

echo "Starting $VALIDATORS local testnet validators..."
for i in $(seq 1 "$VALIDATORS"); do
  grpc_port=$((11000 + i))
  libp2p_port=$((31000 + i))
  jsonrpc_port=$((8500 + i))
  "$BINARY" server \
    --data-dir "$WORKDIR/validator-$i" \
    --chain "$WORKDIR/genesis.json" \
    --grpc-address ":$grpc_port" \
    --libp2p ":$libp2p_port" \
    --jsonrpc "127.0.0.1:$jsonrpc_port" \
    --seal \
    --log-level WARN >"$WORKDIR/validator-$i.log" 2>&1 &
  echo $! >>"$WORKDIR/pids"
done

echo "Testnet started. RPC: http://127.0.0.1:8501"
echo "Logs and PIDs: $WORKDIR"
echo "Stop only these nodes: xargs -r kill < $WORKDIR/pids"
