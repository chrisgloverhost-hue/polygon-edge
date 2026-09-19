#!/usr/bin/env bash
# Fem Chain — Railway deployment startup (single validator per service)
#
# This script runs exactly ONE polygon-edge validator per container/service.
# For a 4-validator IBFT network, deploy this image as 4 separate Railway
# services, each with a different NODE_INDEX (1-4) and its own /app/data
# volume. Railway manages process lifecycle (restarts, health checks), so
# the polygon-edge process is run in the foreground (not backgrounded).
#
# ── Environment variables ───────────────────────────────────────────────
#
#   NODE_INDEX      (1-4, default 1)
#                    Selects which validator identity/ports this service
#                    runs. Each index maps to a distinct data directory,
#                    gRPC port, libp2p port, and JSON-RPC port so multiple
#                    validators never collide even if co-located.
#
#   VALIDATOR_ID     (optional, human-readable label used only for logs)
#
#   PORT             (Railway-injected) Public port for validator 1's
#                     JSON-RPC endpoint. Other validators expose JSON-RPC
#                     only on their internal port (not required to be
#                     public — reachable via Railway private networking).
#
#   BOOTNODES        (optional) Comma or space separated list of libp2p
#                     multiaddrs to use as bootnodes, e.g.:
#                       /dns4/fem-validator-2.railway.internal/tcp/30302/p2p/<PEER_ID>
#                     If unset, falls back to the bootnodes already defined
#                     in genesis.json (Railway private DNS names, not
#                     127.0.0.1), so this is optional for most setups.
#
#   PEER_ADDRESS_1..4 (optional) Individual override for a specific
#                     validator's bootnode multiaddr, e.g. PEER_ADDRESS_2.
#                     Useful when you want to override just one peer
#                     without repeating the full BOOTNODES list. These are
#                     merged into BOOTNODES if provided.
#
# ── Persistence model ───────────────────────────────────────────────────
#
#   Each validator's blockchain state (chain db, IBFT snapshots, and the
#   node's libp2p/BLS keys) lives under:
#
#       /app/data/validator-${NODE_INDEX}/
#
#   Mount a Railway volume at /app/data so this directory survives
#   restarts and deploys. On first boot the directory is created and
#   polygon-edge will generate/persist its keys there; on subsequent
#   boots the existing keys and chain data are reused automatically.
#
# ── Health checks ───────────────────────────────────────────────────────
#
#   Configure the Railway service health check to hit the JSON-RPC
#   endpoint with a real RPC call rather than a bare "/", e.g.:
#
#       POST http://<host>:<port>/  with body {"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}
#
#   A 200 response with a valid JSON-RPC result indicates the node is up
#   and serving requests.

set -e

BINARY="./polygon-edge"
GENESIS="./genesis.json"
PORT="${PORT:-8080}"

# Which validator this service instance represents (1-4).
NODE_INDEX="${NODE_INDEX:-1}"
VALIDATOR_ID="${VALIDATOR_ID:-validator-${NODE_INDEX}}"

# Persistent data directory for this validator only. Backed by the
# /app/data Railway volume so keys and chain state survive restarts.
DATA_DIR="/app/data/validator-${NODE_INDEX}"
mkdir -p "$DATA_DIR"

# Per-node network ports. Keeping these distinct means multiple
# validators can also still be run side-by-side on one host if needed.
GRPC_ADDR=":1000${NODE_INDEX}"
LIBP2P_ADDR=":3030${NODE_INDEX}"

# JSON-RPC bind address. Validator 1 binds to Railway's public $PORT;
# the others default to fixed internal ports (reachable over Railway
# private networking, or locally for debugging).
case "$NODE_INDEX" in
  1) JSONRPC_ADDR="0.0.0.0:${PORT}" ;;
  2) JSONRPC_ADDR=":10202" ;;
  3) JSONRPC_ADDR=":10203" ;;
  4) JSONRPC_ADDR=":10204" ;;
  *) JSONRPC_ADDR=":102${NODE_INDEX}0" ;;
esac

# ── Bootnode discovery ──────────────────────────────────────────────────
# Preference order:
#   1. Explicit BOOTNODES env var (comma or space separated multiaddrs)
#   2. Individual PEER_ADDRESS_N overrides, merged together
#   3. Fall back to the bootnodes already baked into genesis.json, which
#      use Railway private DNS names (fem-validator-N.railway.internal)
#      rather than 127.0.0.1, so cross-service discovery works out of
#      the box without any extra configuration.
BOOTNODE_ARGS=()

if [ -n "${BOOTNODES:-}" ]; then
  # Support comma- or space-separated lists.
  IFS=', ' read -r -a BOOTNODE_ARGS <<< "${BOOTNODES}"
else
  for i in 1 2 3 4; do
    var="PEER_ADDRESS_${i}"
    val="${!var:-}"
    if [ -n "$val" ]; then
      BOOTNODE_ARGS+=("$val")
    fi
  done
fi

BOOTNODE_FLAGS=()
for addr in "${BOOTNODE_ARGS[@]}"; do
  BOOTNODE_FLAGS+=(--bootnode "$addr")
done

echo "=============================="
echo "  Fem Chain — Railway Deploy"
echo "  Validator : ${VALIDATOR_ID} (NODE_INDEX=${NODE_INDEX})"
echo "  Chain ID  : 23124"
echo "  Token     : FEM"
echo "  Data dir  : ${DATA_DIR}"
echo "  JSON-RPC  : ${JSONRPC_ADDR}"
echo "  gRPC      : ${GRPC_ADDR}"
echo "  libp2p    : ${LIBP2P_ADDR}"
if [ "${#BOOTNODE_ARGS[@]}" -gt 0 ]; then
  echo "  Bootnodes : ${BOOTNODE_ARGS[*]} (override)"
else
  echo "  Bootnodes : from genesis.json (Railway private DNS)"
fi
echo "=============================="

# Run this single validator in the foreground. Do NOT background (&) the
# process — Railway supervises the container's PID 1 for restarts and
# crash detection, and backgrounding would hide failures from it.
exec "$BINARY" server \
  --data-dir "$DATA_DIR" \
  --chain "$GENESIS" \
  --grpc-address "$GRPC_ADDR" \
  --libp2p "$LIBP2P_ADDR" \
  --jsonrpc "$JSONRPC_ADDR" \
  "${BOOTNODE_FLAGS[@]}" \
  --seal \
  --price-limit 1000000000 \
  --log-level INFO
