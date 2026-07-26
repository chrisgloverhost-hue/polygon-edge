# Fem Chain Mainnet Launch Checklist

## ✅ Done
- [x] Genesis block created (block 0, hash `0x533b2f2c...`)
- [x] 4 validator nodes configured (IBFT PoA, BLS keys)
- [x] Gas price floor set to 1 gwei on all validators
- [x] JSON-RPC exposed on port 80 (public via Replit)
- [x] Chain running and producing blocks (~2s block time)
- [x] Docker / Railway deployment ready (`Dockerfile`, `railway.toml`)
- [x] Validator join guide written (`docs/validator-guide.md`)
- [x] Token distribution plan written (`docs/token-distribution.md`)
- [x] Chainlist submission file created (`docs/chainlist-submission/eip155-23124.json`)

## 🔲 To Do — Before Public Announcement

### 1. Publish to Replit (stable URL)
- Click **Publish** in Replit to get a permanent `*.replit.app` URL
- This becomes your stable public RPC endpoint
- Update `docs/chainlist-submission/eip155-23124.json` with the real URL

### 2. Submit to Chainlist.org
- Fork https://github.com/ethereum-lists/chains
- Copy `docs/chainlist-submission/eip155-23124.json` → `_data/chains/eip155-23124.json`
- Open a Pull Request
- Once merged, users can add Fem Chain in MetaMask via chainlist.org

### 3. Add external validators (decentralization)
- Share `docs/validator-guide.md` with trusted node operators
- They set up nodes on separate servers and share their validator addresses
- Existing validators vote them in: `polygon-edge ibft propose --addr <addr> --vote auth`
- Aim for ≥7 independent validators for meaningful decentralization

### 4. Public bootnode
- After publishing, update the bootnode URL in `start-fem-chain.sh` from
  `127.0.0.1` to your server's public IP or domain
- Announce the bootnode address so external nodes can discover peers

### 5. Block explorer (recommended)
- Deploy Blockscout or Otterscan pointed at your public RPC
- Add the explorer URL to `docs/chainlist-submission/eip155-23124.json`

### 6. Token distribution
- Follow the plan in `docs/token-distribution.md`
- Set up a multisig treasury wallet for ecosystem funds

### 7. Register FEM token
- Submit to CoinGecko: https://www.coingecko.com/en/coins/new
- Submit to CoinMarketCap: https://coinmarketcap.com/request/
- (Requires a live explorer URL and community presence)

---

## Network Details (final)

| Property | Value |
|----------|-------|
| Chain ID | 23124 |
| Token | FEM |
| Decimals | 18 |
| Total supply | 4,000,000 FEM |
| Block time | ~2 seconds |
| Gas price | 1 gwei minimum |
| Block gas limit | 10,000,000 |
| Consensus | IBFT PoA |
| EVM compatible | Yes (Istanbul fork) |
