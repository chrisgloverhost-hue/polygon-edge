# Fem Chain

Your own Ethereum-compatible blockchain running on Polygon Edge with 4 validators.

## Chain Details

| Setting | Value |
|---|---|
| Network name | Fem |
| Chain ID | 23124 |
| Native token | FEM (Fem chain) |
| Consensus | IBFT (4 validators) |
| JSON-RPC | port 8080 |

## Connect MetaMask (add your chain to a wallet)

1. Open MetaMask → **Add a custom network**
2. Fill in:
   - **Network Name**: Fem
   - **RPC URL**: `https://06df4580-421a-4b8c-b4b5-26044a094a75-00-3rxyuf5618lmb.kirk.replit.dev:8080`
   - **Chain ID**: `23124`
   - **Currency Symbol**: `FEM`
3. Save and switch to the Fem network

> **Note**: The RPC URL above is the dev URL and changes if you restart the Repl. For a permanent public URL, deploy the project (Replit Deployments).

## Validator Wallet Addresses (pre-mined with 1,000,000 FEM each)

| # | Address |
|---|---|
| 1 | `0xe2C84f1a57151b1a22e0fbfb92542881Ac95e8d7` |
| 2 | `0x246Bd0e7Da038524F3341a9dfB874173b00BB437` |
| 3 | `0x939B951C6CFdB409BDD2f67Fe94b9Fe94597273c` |
| 4 | `0x95C06222EFc6463B8882cEFad9bfb45025772FAD` |

Private keys are stored in `fem-chain-1/` through `fem-chain-4/` (insecure local storage — for devnet only).

## Running the Chain

**Start** (workflow): The "Fem Chain Devnet" workflow starts all 4 nodes automatically.

**Stop all nodes**:
```bash
bash stop-fem-chain.sh
```

**Rebuild the binary** (after code changes):
```bash
GOPROXY=direct GONOSUMDB=* go build -o polygon-edge \
  -ldflags="-X 'github.com/0xPolygon/polygon-edge/versioning.Version=v1.0.0'" \
  main.go
```

## Project Structure

```
main.go               — Entry point
command/default.go    — Chain name (Fem) and chain ID (23124)
genesis.json          — Genesis block (chain config + initial validators)
fem-chain-1/ to 4/    — Validator data dirs + private keys
start-fem-chain.sh    — Starts all 4 nodes
stop-fem-chain.sh     — Stops all nodes
polygon-edge          — Built binary
```

## Deploying Tokens

Once MetaMask is connected to the Fem network, you can deploy ERC-20 or ERC-721 token contracts using Hardhat, Remix, or Foundry — just point them at the Fem RPC URL.

## User Preferences
- Build with `GOPROXY=direct GONOSUMDB=*` — required to bypass Replit's package firewall for this project.
- Consensus: IBFT (PolyBFT requires a rootchain bridge, which is not needed for a standalone chain).
