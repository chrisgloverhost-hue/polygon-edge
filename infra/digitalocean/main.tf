terraform {
  required_version = ">= 1.6.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.100"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}

locals {
  validator_nodes = {
    for index in range(var.validator_count) :
    format("fem-validator-%03d", index + 1) => {
      region = var.regions[index % length(var.regions)]
    }
  }
}

resource "digitalocean_tag" "validators" {
  name = "fem-mainnet-validator"
}

resource "digitalocean_droplet" "validator" {
  for_each = local.validator_nodes

  name       = each.key
  region     = each.value.region
  size       = var.droplet_size
  image      = var.image
  monitoring = true
  ipv6       = true
  tags       = [digitalocean_tag.validators.name]
  ssh_keys   = [var.ssh_key_fingerprint]

  # This creates only the hardened host. Generate validator/BLS/libp2p keys on
  # each host after reviewing its public address; never put key material here.
  user_data = <<-CLOUDINIT
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - ca-certificates
      - curl
      - jq
      - unattended-upgrades
    users:
      - name: femnode
        shell: /bin/bash
        groups: [sudo]
        sudo: ["ALL=(ALL) NOPASSWD:ALL"]
        lock_passwd: true
    runcmd:
      - mkdir -p /opt/fem /var/lib/fem
      - chown -R femnode:femnode /opt/fem /var/lib/fem
  CLOUDINIT
}

resource "digitalocean_firewall" "validators" {
  name = "fem-mainnet-validators"
  tags = [digitalocean_tag.validators.name]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.admin_cidrs
  }

  # P2P only. gRPC/admin and JSON-RPC remain private on validator hosts.
  inbound_rule {
    protocol         = "tcp"
    port_range       = "30301"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "validator_public_ips" {
  value = {
    for name, node in digitalocean_droplet.validator : name => node.ipv4_address
  }
}
