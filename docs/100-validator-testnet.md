# 100-Validator Testnet Gate

The 100-node launcher is [`scripts/cluster-ibft-100.sh`](../scripts/cluster-ibft-100.sh).
It creates intentionally insecure disposable keys for a local testnet; it does not
create, modify, or validate the production mainnet genesis.

Run it only in a Linux/WSL test environment with sufficient CPU, memory, and available
ports. Start with a dedicated host of at least 16 vCPU, 32 GB RAM, and 100 GB SSD;
measure actual resource use and increase capacity before repeating under load.

```bash
go build -o polygon-edge .
FEM_TESTNET_CONFIRM=YES ./scripts/cluster-ibft-100.sh
```

Required evidence to pass this gate:

1. All 100 processes remain healthy for at least 72 hours.
2. The validator set reports exactly 100 distinct validators.
3. Finality continues after controlled restarts of 1, 10, and 33 validators.
4. A simulated loss/partition of 34 validators halts finality safely; recovery is
   rehearsed without state divergence.
5. Sustained transaction load meets the approved block-time, latency, and error-rate
   thresholds, with CPU/disk/network graphs retained.
6. No production key, address, or allocation appears in the testnet files.

Passing this testnet gate does not authorize mainnet launch by itself. The final
manifest, genesis ceremony, security audit, and operations gates still apply.
