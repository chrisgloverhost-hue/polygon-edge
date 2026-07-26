# Fem Chain — External Validator Guide

Fem Chain is an IBFT Proof-of-Authority blockchain. Validators are a fixed set
approved by existing validators. This guide shows how to run a full node and,
separately, how existing validators can vote in a new one.

---

## Requirements

| Item | Minimum spec |
|------|-------------|
| OS | Ubuntu 22.04 / Debian 12 / Alpine 3.18 |
| CPU | 2 vCPU |
| RAM | 4 GB |
| Disk | 50 GB SSD |
| Network | Public static IP, open ports below |

**Required open ports:**

| Port | Protocol | Purpose |
|------|----------|---------|
| 30301 | TCP | libp2p (peer discovery) |
| 8545 | TCP | JSON-RPC (optional, public) |
| 10000 | TCP | gRPC (optional, internal) |

---

## 1. Install the binary

```bash
# Download pre-built binary
wget https://github.com/0xPolygon/polygon-edge/releases/download/v1.0.0/polygon-edge_1.0.0_linux_amd64.tar.gz
tar -xzf polygon-edge_1.0.0_linux_amd64.tar.gz
chmod +x polygon-edge
sudo mv polygon-edge /usr/local/bin/

# Or build from source (Go 1.21 required)
git clone https://github.com/0xPolygon/polygon-edge
cd polygon-edge
go build -o polygon-edge main.go
```

---

## 2. Create a node identity

```bash
polygon-edge secrets init --data-dir ./fem-node
```

This creates:
- `fem-node/consensus/validator.key` — your validator private key
- `fem-node/libp2p/libp2p.key` — your networking identity

**Save your validator address** — you will need it in step 4:

```bash
polygon-edge secrets output --data-dir ./fem-node
```

---

## 3. Get the genesis file

```bash
# Download the official Fem Chain genesis
wget https://raw.githubusercontent.com/your-org/fem-chain/main/genesis.json
```

Or copy it from an existing node. Verify its hash:

```
Genesis hash: 0x533b2f2c69a44c0062e8262b5db810e5ab92fdedb17f4957b2e61719d968a6da
```

---

## 4. Request validator admission

Fem Chain uses IBFT — new validators require a majority vote from existing
validators. To be added:

1. Share your **validator address** (from step 2) with an existing validator
2. They run: `polygon-edge ibft propose --addr <your-address> --vote auth --grpc-address :10000`
3. A majority of current validators must cast the same vote
4. Once the threshold is reached you are added to the active validator set

To check current validators:

```bash
polygon-edge ibft status --grpc-address :10000
```

---

## 5. Start your node

```bash
polygon-edge server \
  --data-dir ./fem-node \
  --chain genesis.json \
  --grpc-address :10000 \
  --libp2p 0.0.0.0:30301 \
  --jsonrpc 0.0.0.0:8545 \
  --seal \
  --price-limit 1000000000 \
  --bootnodes "/ip4/127.0.0.1/tcp/30301/p2p/16Uiu2HAm4WSy6yu6nyHyqFoaYSSy2EGCb97BV81LV3dvPFozXvsb" \
  --log-level INFO
```

> Replace the bootnode `/ip4/127.0.0.1/...` with the public Fem Chain bootnode
> address once it is published at fem.network/bootnodes.

---

## 6. Run as a systemd service (recommended)

```ini
# /etc/systemd/system/fem-node.service
[Unit]
Description=Fem Chain Node
After=network.target

[Service]
ExecStart=/usr/local/bin/polygon-edge server \
  --data-dir /opt/fem-node \
  --chain /opt/fem-node/genesis.json \
  --grpc-address :10000 \
  --libp2p 0.0.0.0:30301 \
  --jsonrpc 0.0.0.0:8545 \
  --seal \
  --price-limit 1000000000 \
  --log-level INFO
Restart=always
RestartSec=5
User=femnode

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable fem-node
sudo systemctl start fem-node
sudo journalctl -fu fem-node
```

---

## Useful commands

```bash
# Check sync status
curl -s -X POST http://localhost:8545 \
  -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# Check peers
polygon-edge peers list --grpc-address :10000

# Check IBFT validator set
polygon-edge ibft status --grpc-address :10000

# Propose adding a validator (existing validators only)
polygon-edge ibft propose --addr <address> --vote auth --grpc-address :10000

# Propose removing a validator
polygon-edge ibft propose --addr <address> --vote drop --grpc-address :10000
```

---

## Network details

| Property | Value |
|----------|-------|
| Chain ID | 23124 |
| Token | FEM |
| Consensus | IBFT PoA |
| Block time | ~2 seconds |
| Gas price min | 1 gwei |
| Gas limit/block | 10,000,000 |
