# DigitalOcean: 100 Fem Chain Validator Hosts

This Terraform configuration creates **100 Ubuntu hosts** across five DigitalOcean
regions, tagged as `fem-mainnet-validator`. It does not generate validator keys,
create a genesis file, start a chain, or publish RPC. That separation is intentional:
production private keys must never appear in Terraform state, Git, chat, or cloud-init.

## Before applying

1. Confirm DigitalOcean account quotas permit 100 droplets in the listed regions.
2. Add an SSH public key to DigitalOcean and get its existing fingerprint/ID.
3. Determine your public administration IP as a `/32` CIDR.
4. Estimate and approve the monthly cost for 100 `s-2vcpu-4gb` droplets.
5. Store the API token only in your local environment; never add it to a `.tfvars`
   file that might be committed.

## Plan only

```bash
cd infra/digitalocean
export TF_VAR_digitalocean_token='your-token'
terraform init
terraform plan \
  -var 'ssh_key_fingerprint=your-fingerprint' \
  -var 'admin_cidrs=["YOUR.PUBLIC.IP/32"]'
```

`terraform apply` is intentionally not run by this repository. It creates 100
billable servers. After the plan is reviewed and applied, generate each validator's
keys on its own host, collect public identities into the mainnet manifest, and run the
genesis preflight before any mainnet ceremony.
