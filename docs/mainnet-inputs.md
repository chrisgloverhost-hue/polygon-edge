# Fem Chain Mainnet Input Sheet

Provide public information only. Never put seed phrases, private keys, keystores, API
keys, passwords, or cloud credentials in this repository or chat.

## 1. Network identity

- Legal project/entity name:
- Public network name:
- FEM token name, symbol, decimals (proposed: FEM / 18):
- Website, documentation domain, and security-contact email:
- Owner-confirmed EIP-155 chain ID: **23124**
- Launch-date window:
- Bridge scope at launch: none / selected assets / full bridge (specify):

## 2. Token allocation: exactly 1,000,000,000 FEM

Every destination must be a public address, preferably an audited multisig. Amounts
must total exactly 1,000,000,000 FEM.

| Bucket | Public receiving address | Amount FEM | Multisig threshold | Lockup / vesting | Purpose |
|---|---|---:|---|---|---|
| Validator bootstrap | | | | | |
| Treasury | | | | | |
| Ecosystem | | | | | |
| Team | | | | | |
| Community | | | | | |
| Liquidity | | | | | |
| Other | | | | | |
| **Total** | | **1,000,000,000** | | | |

State whether supply is permanently fixed. If it is not, specify the cap, minting
authority, multisig threshold, timelock, and audited contract.

## 3. Validator manifest: 100 entries required

Generate production keys independently on each node. Submit public information only.

| # | Node label | Region | Provider/account | ECDSA validator address | BLS public key | libp2p peer ID | Public DNS/IP | Operations contact |
|---:|---|---|---|---|---|---|---|---|
| 1 | | | | | | | | |
| 2 | | | | | | | | |
| ... | | | | | | | | |
| 100 | | | | | | | | |

Also provide host architecture, key-management/backup design, and the signed public
key ownership attestations. Do not provide the private material.

## 4. Decisions to approve in writing

- IBFT PoA confirmation (or another audited consensus design):
- Block time/gas limit (test baseline: 2 seconds / 10,000,000 gas):
- Fee policy and fee-recipient/burn policy:
- Validator admission/removal, governance multisig, and timelock:
- Upgrade/emergency policy and notice period:
- Contracts/bridges enabled at genesis plus source commits/audits:

## 5. Infrastructure and evidence

- At least three bootnode domains/operators/regions/peer IDs:
- Public RPC domains/operators/rate limits:
- Explorer/indexer operator/domain:
- Monitoring/on-call escalation contact:
- Client commit, SBOM, release checksum/signature:
- Audit reports and remediation evidence:
- Testnet duration, load-test, chaos-test, and recovery-drill results:
- Legal sign-off and named launch go/no-go approver:
