# FEM Token Distribution Plan

## Overview

Total supply at genesis: **4,000,000 FEM** (1,000,000 per validator address)

FEM is the native currency of Fem Chain. It is used to pay gas fees (minimum
1 gwei per transaction) and will serve as the economic backbone of the network.

---

## Genesis Allocation

| Address | Amount | Role |
|---------|--------|------|
| `0x246Bd0e7Da038524F3341a9dfB874173b00BB437` | 1,000,000 FEM | Validator 2 |
| `0x939B951C6CFdB409BDD2f67Fe94b9Fe94597273c` | 1,000,000 FEM | Validator 3 |
| `0x95C06222EFc6463B8882cEFad9bfb45025772FAD` | 1,000,000 FEM | Validator 4 |
| `0xe2C84f1a57151b1a22e0fbfb92542881Ac95e8d7` | 1,000,000 FEM | Validator 1 |
| **Total** | **4,000,000 FEM** | |

---

## Recommended Distribution Strategy

### Phase 1 — Foundation (now)
- Validator wallets hold genesis allocation
- Used for network operations, gas, and initial liquidity seeding

### Phase 2 — Community Airdrop
- Allocate a portion for early adopters and testers
- Recommend: 500,000–1,000,000 FEM airdrop pool
- Criteria: wallet age, on-chain activity, community contribution

### Phase 3 — Ecosystem Fund
- Reserve tokens for grants to developers building on Fem Chain
- Recommend: 10–20% of supply set aside in a multisig treasury

### Phase 4 — Exchange Listing
- To list FEM on a DEX or CEX:
  1. Deploy a wrapped ERC-20 version on Ethereum/Polygon (bridge)
  2. Seed a liquidity pool (e.g. FEM/USDC on Uniswap V2)
  3. Submit to CoinGecko and CoinMarketCap for tracking

---

## Increasing Total Supply

Fem Chain's IBFT PoA does not have built-in block rewards. To mint new tokens:

1. Deploy a **minting contract** that only validators can call
2. Or increase genesis `alloc` balances before launch (requires regenesis)

To add a minting contract post-launch:
```solidity
// Example: only owner can mint
function mint(address to, uint256 amount) external onlyOwner {
    _mint(to, amount);
}
```

---

## Gas Fee Revenue

Since gas price = 1 gwei and there is no `burnContract`, **100% of gas fees go
to the block proposer** (validator). This is a passive revenue stream for
validators proportional to their block production.

At 10,000 transactions/day at 65,000 gas (ERC-20 transfer):
- Daily gas revenue ≈ 0.65 FEM per validator
- Monthly ≈ ~20 FEM per validator

---

## Notes

- No new FEM can be created without a contract or regenesis — supply is
  effectively fixed at 4,000,000 FEM unless you deploy a mint contract.
- The `burnContract` in `genesis.json` is null — fees are NOT burned.
- FEM has 18 decimals (same as ETH/ERC-20 standard).
