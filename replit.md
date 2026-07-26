# Polygon Edge — Custom Blockchain

A custom Ethereum-compatible blockchain node built on [Polygon Edge](https://github.com/0xPolygon/polygon-edge). Use it to run your own chain where others can deploy smart contracts and create tokens.

## Stack
- **Language**: Go 1.21
- **Framework**: Polygon Edge v1.0.0
- **Consensus**: IBFT 2.0 or PolyBFT (configurable)

## Building

```bash
GOPROXY=direct GONOSUMDB=* go build -o polygon-edge \
  -ldflags="-X 'github.com/0xPolygon/polygon-edge/versioning.Version=v1.0.0'" \
  main.go
```

> **Note**: `GOPROXY=direct` is required because Replit's package firewall blocks some dependency versions; building directly from upstream works fine.

## Quick Start — Launch a Local Devnet

### 1. Generate validator secrets
```bash
./polygon-edge polybft-secrets --data-dir test-chain-1 --num 4
```

### 2. Create genesis block
```bash
./polygon-edge genesis --consensus polybft --block-gas-limit 10000000 \
  --epoch-size 10 [--validators from secrets output]
```

### 3. Start a node
```bash
./polygon-edge server --data-dir ./test-chain-1 --chain ./genesis.json \
  --grpc-address :10000 --libp2p :30301 --jsonrpc :10002
```

## Customizing Your Chain

| What to change | Where |
|---|---|
| Chain name & ID | `command/default.go` — `DefaultChainName`, `DefaultChainID` |
| Native token name | `chain/params.go` |
| Block gas limit / epoch | `genesis` command flags |
| Consensus engine | `--consensus ibft` or `--consensus polybft` |
| Pre-mined addresses | `--premine` flag in `genesis` |

## Project Structure

```
main.go            — Entry point
command/           — CLI commands (genesis, server, polybft-secrets, …)
consensus/         — IBFT and PolyBFT consensus implementations
blockchain/        — Block storage and chain management
jsonrpc/           — Ethereum JSON-RPC API
network/           — libp2p peer networking
state/             — EVM state and execution
```

## User Preferences
- Build with `GOPROXY=direct GONOSUMDB=*` to bypass Replit's package firewall for this project.
