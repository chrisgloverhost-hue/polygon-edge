# Railway Demo RPC Deployment

Railway is for a temporary Fem Chain demonstration RPC only. It is not a mainnet
validator host and must not hold production validator keys or the final mainnet
genesis.

## Deploy

1. Create a new Railway project and choose **Deploy from GitHub repository**.
2. Select this repository. Railway detects the included `Dockerfile`.
3. In the service networking settings, generate a Railway domain. Railway supplies the
   `PORT` environment variable; `start-railway.sh` binds JSON-RPC to that port.
4. Wait for the deployment log to show all four *development* validators started.
5. Test the generated URL using a JSON-RPC POST request. Replace `URL`:

```bash
curl -X POST https://URL \
  -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

The response must be `0x5a54` (decimal 23124). Then run `eth_blockNumber` twice,
several seconds apart; the second result must be higher.

## Do not publish this deployment as mainnet

This repository's current Railway image contains four development validators and a
4,000,000 FEM development genesis. Do not add its URL to Chainlist or announce it as
mainnet. The Chainlist draft intentionally has no RPC, website, or explorer until
those services are live and verified.
