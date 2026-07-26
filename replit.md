# Fem Chain — Polygon Edge Devnet

A 4-validator IBFT (Proof of Authority) Ethereum-compatible devnet built on [Polygon Edge](https://github.com/0xPolygon/polygon-edge) v1.0.0.

## Stack
- **Language**: Go 1.21
- **Framework**: Polygon Edge (fork of 0xPolygon/polygon-edge)
- **Consensus**: IBFT PoA (4 validators)

## How to run

The workflow **"Fem Chain Devnet"** builds and starts the chain automatically.

To build the binary manually:
```bash
GOPROXY=direct GONOSUMDB=* go build -o polygon-edge \
  -ldflags="-X 'github.com/0xPolygon/polygon-edge/versioning.Version=v1.0.0' \
            -X 'github.com/0xPolygon/polygon-edge/versioning.Branch=main'" main.go
```

To start the devnet manually:
```bash
bash start-fem-chain.sh
```

## Network details

| Property       | Value                          |
|----------------|-------------------------------|
| Network name   | Fem                            |
| Chain ID       | 23124                          |
| Currency       | FEM                            |
| JSON-RPC       | `http://0.0.0.0:8080`         |
| Block time     | ~2 seconds                     |
| Gas price      | **0 wei** (free transactions)  |
| Gas limit/block| 10,000,000                     |
| Consensus      | IBFT PoA                       |

## MetaMask connection

1. Open MetaMask → Add Network → Add a network manually
2. Fill in:
   - **Network name**: Fem
   - **RPC URL**: `https://<your-replit-url>.replit.dev` (port 80 → maps to 8080)
   - **Chain ID**: `23124`
   - **Currency symbol**: `FEM`

## Pre-funded validator accounts

| Address | Balance |
|---------|---------|
| `0x246Bd0e7Da038524F3341a9dfB874173b00BB437` | 1,000,000 FEM |
| `0x939B951C6CFdB409BDD2f67Fe94b9Fe94597273c` | 1,000,000 FEM |
| `0x95C06222EFc6463B8882cEFad9bfb45025772FAD` | 1,000,000 FEM |
| `0xe2C84f1a57151b1a22e0fbfb92542881Ac95e8d7` | 1,000,000 FEM |

> Private keys for these accounts are stored in the `fem-chain-*/consensus/` directories.

## Validator nodes

| Node | gRPC    | libp2p | JSON-RPC |
|------|---------|--------|----------|
| 1    | :10000  | :30301 | :8080 (public) |
| 2    | :10002  | :30302 | :10202 |
| 3    | :10003  | :30303 | :10203 |
| 4    | :10004  | :30304 | :10204 |

## Gas fees

Gas price is **0 wei** — transactions on Fem Chain are free. The chain does not use EIP-1559 base fees. The `burnContract` field in `genesis.json` is null, confirming no fee burning.

## User preferences
