# Fem Chain Owner Mainnet Specification (v0.1)

This is the default owner-controlled launch specification for review. It becomes
final only when the placeholder public addresses and the 100-validator manifest are
signed off during the genesis ceremony.

## 1. Fixed FEM supply and allocation

FEM has 18 decimals and a fixed genesis supply of **1,000,000,000 FEM**. No minting
function, inflation mechanism, or discretionary issuance authority will exist at
launch. Allocation wallets must be distinct hardware-wallet multisigs; replace each
placeholder with its public address before genesis generation.

| Bucket | FEM | Share | Custody | Locking policy |
|---|---:|---:|---|---|
| Treasury | 300,000,000 | 30% | 3-of-5 owner treasury multisig | 24-month timelock; public monthly reports |
| Ecosystem grants | 200,000,000 | 20% | 3-of-5 grants multisig | 48-month program budget; quarterly releases |
| Team/founder | 150,000,000 | 15% | Separate 3-of-5 vesting multisig | 12-month cliff then 36-month linear vesting |
| Validator bootstrap | 100,000,000 | 10% | 3-of-5 validator rewards multisig | 48-month transparent reward program |
| Community | 100,000,000 | 10% | 3-of-5 community multisig | Claim/distribution contracts require audit |
| Liquidity | 100,000,000 | 10% | 3-of-5 liquidity multisig | Transfers announced 7 days in advance |
| Contingency reserve | 50,000,000 | 5% | Separate 3-of-5 reserve multisig | 48-month timelock; emergency use publicly disclosed |
| **Total** | **1,000,000,000** | **100%** | | |

No allocation is permitted to a personal externally owned account. The multisig signer
set should use independent hardware devices and a documented signer-replacement
procedure.

## 2. One-owner, 100-validator operating model

At launch, Fem Chain is a **permissioned IBFT PoA network controlled by its founder**.
This must be stated in the website, documentation, wallet metadata, and token
disclosures. The target is 100 validators, each with:

- its own fresh ECDSA validator key, BLS key, and libp2p identity;
- a dedicated host/account and encrypted backup; no cloned data directories;
- placement across at least 5 regions and 3 infrastructure providers;
- private gRPC/admin access; only required P2P ports publicly exposed;
- one of at least three independent bootnodes; and
- monitoring for missed blocks, peer count, disk, CPU, memory, block lag, and RPC
  error rate.

Never generate production keys on this workstation. Generate each key on its target
host or secure offline ceremony system, store only public identity material in the
validator manifest, and keep private material in a hardware-backed secret system.

Before admitting all 100 validators, prove the final client works with 100 nodes on a
public testnet under restart, partition, and load scenarios. Do not substitute a
four-node test for this gate.

## 3. Network identity

| Field | Decision |
|---|---|
| Network name | Fem Chain Mainnet |
| Native currency | FEM |
| Decimals | 18 |
| Owner-confirmed chain ID | 23124 (`0x5a54`) |
| Consensus | IBFT PoA / BLS |
| Block time | 2 seconds, subject to 100-validator testnet results |
| Block gas limit | 10,000,000, subject to load-test evidence |
| Initial bridge scope | No bridge at genesis |
| Public launch date | Not set; after all launch gates pass |

The owner confirms Fem Chain ID 23124. The current Chainlist submission uses the same
identity; keep every wallet, explorer, RPC, and registry record consistent with it.
The genesis ceremony must reject any artifact whose network name, symbol, or chain ID
does not match these owner-confirmed values.

## 4. Governance, fees, and upgrades

- Supply: permanently fixed at 1B FEM.
- Governance: owner-controlled 3-of-5 multisig at launch; every signer action is
  logged publicly. Changes to validator set, client upgrade, or treasury execution use
  a 48-hour timelock except a documented chain-security emergency.
- Emergency: a separate 3-of-5 emergency multisig may coordinate a temporary
  operational response. It cannot mint FEM or transfer treasury funds. Every use must
  be announced within 24 hours and reviewed publicly within 7 days.
- Fees: EIP-1559 base fee is enabled. The initial transaction floor is 1 gwei; fee
  recipient/burn behavior is frozen in the final genesis and documented before launch.
- Bridges: none at genesis. Any later bridge requires a separate threat model,
  independent audit, capped rollout, monitoring, and an emergency-pause policy.
- Upgrades: source and binary release must be announced at least 14 days ahead; an
  emergency security release requires 48-hour post-incident disclosure. Every upgrade
  is rehearsed on the final testnet first.

## What is still needed before execution

1. Seven public multisig addresses matching the allocation table.
2. The public manifests for 100 validator nodes and three bootnodes.
3. Legal entity/domain/contact details and testnet/audit evidence.

Those are intentionally not invented here: they are public identity and custody
commitments that must belong to you, not to this codebase.
