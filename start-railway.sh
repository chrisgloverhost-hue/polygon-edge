#!/usr/bin/env bash
# Fem Chain — Railway deployment startup
#
# This script is now a no-op wrapper. Each validator service on Railway
# is deployed independently and provides its own startCommand, e.g.:
#
#   ./polygon-edge server \
#     --data-dir /data/validator1 \
#     --chain ./genesis.json \
#     --grpc-address :10000 \
#     --libp2p :30301 \
#     --jsonrpc 0.0.0.0:8080 \
#     --seal \
#     --price-limit 1000000000 \
#     --log-level INFO
#
# The data directory for each validator is backed by its own Railway
# volume, so validators can be scaled, restarted, and managed independently.

set -e

exec ./polygon-edge "$@"
