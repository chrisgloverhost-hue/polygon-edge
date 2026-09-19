# Fem Chain Mainnet Launch Plan

## Status: not approved for launch

The checked-in `genesis.json`, `fem-chain-*` directories, and `start-fem-chain.sh`
are a **four-validator local development network**. They must not be reused for
mainnet. Its bootnodes use `127.0.0.1`, its validator material has existed in a
working directory, and its genesis allocates 4,000,000 FEM, not 1,000,000,000 FEM.

## Intended mainnet baseline

| Property | Target |
|---|---|
| Native currency | FEM, 18 decimals |
| Genesis supply | 1,000,000,000 FEM |
| Initial validators | 100 production validators |
| Consensus | IBFT PoA with BLS validator keys |
| Governance | Owner-controlled initially; all authority protected by multisig and timelock |
| Chain ID | Newly verified, unclaimed EIP-155 ID; do not assume `23124` is available |
| Genesis | New, reproducibly generated and independently verified |

Owning the project alone is compatible with a permissioned launch. It is not a
decentralized network if you operate or control all validators; describe it publicly as
founder-controlled/permissioned until governance and validators are independently run.

## Required launch gates

### Governance, legal, and token policy

- [ ] Legal counsel confirms the entity, jurisdictions, sanctions policy, privacy,
  terms, distribution, and applicable token/consumer-law obligations.
- [ ] A written allocation table reconciles exactly to 1,000,000,000 FEM. Every
  material allocation is held by a hardware-wallet multisig, not a single wallet.
- [ ] Written rules define validator changes, upgrades, treasury use, bridge pauses,
  incident authority, announcement process, and a future decentralization path.

### Validator and protocol security

- [ ] Generate 100 new production key sets outside this repository. Never share a
  private key, seed phrase, keystore, cloud credential, or password in chat or Git.
- [ ] Spread the nodes across regions/providers/accounts and use distinct access keys,
  backups, and recovery plans. One owner can operate them, but avoid a single server,
  account, or key compromising every validator.
- [ ] Pin a reviewed client commit/toolchain; produce signed release binaries, SBOM,
  checksums, and reproducible builds.
- [ ] Complete independent protocol/cryptography/RPC/P2P/genesis/dependency audits;
  resolve all critical/high findings and run a paid bug bounty.
- [ ] Generate the final genesis twice in clean environments and compare it exactly.
  Two independent verifiers must check the hash, chain ID, 100 validators, bootnodes,
  fork schedule, and full 1B allocation.
- [ ] Complete a sustained testnet and load/partition/restart/key-recovery drills using
  the final client and equivalent topology.

### Operations and public infrastructure

- [ ] Use dedicated hardened Linux hosts for validators, never Replit/Railway.
- [ ] Operate at least three public bootnodes; run public RPC, metrics, and explorer on
  separate, rate-limited infrastructure. gRPC/admin/debug endpoints remain private.
- [ ] Configure TLS, firewalls, DDoS controls, encrypted backups, alerting, log
  retention, secret rotation, and 24/7 on-call coverage.
- [ ] Test incident, chain-stall, compromised-key, upgrade, rollback, restore, and
  public-communications runbooks.

## Final launch sequence

1. Freeze source, dependencies, allocations, validator manifest, domains, and policy.
2. Build/sign the release and generate genesis from the approved manifest in an
   offline, recorded ceremony.
3. Distribute signed binary, genesis hash, and public bootnodes through a verified
   channel. Each node independently validates the artifacts.
4. Start the 100 nodes privately; verify peer count, consensus, validator set, RPC,
   monitoring, and allocation totals.
5. Observe for 24–72 hours with bridge/treasury transfers disabled. Abort on any
   consensus, security, or allocation discrepancy.
6. Enable public services and announce only after a formal go/no-go sign-off.

## Explicit no-go conditions

Do not launch if fewer than 100 valid production entries are in the genesis manifest,
if any production key touched the repository/chat, if allocations do not total exactly
1,000,000,000 FEM, if audit/drills are incomplete, or if public infrastructure has a
single failure domain.

## Inputs required from the owner

Complete [`mainnet-inputs.md`](mainnet-inputs.md). The next technical deliverable is a
reviewable validator/allocation manifest and reproducible genesis ceremony—not a
modification of the present development genesis.
