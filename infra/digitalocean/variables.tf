variable "digitalocean_token" {
  type      = string
  sensitive = true
}

variable "ssh_key_fingerprint" {
  type        = string
  description = "Fingerprint or ID of an existing DigitalOcean SSH key."
}

variable "admin_cidrs" {
  type        = list(string)
  description = "Public CIDRs permitted to SSH to validators. Never use 0.0.0.0/0."
}

variable "validator_count" {
  type        = number
  default     = 100
  description = "Must remain 100 for the intended Fem Chain mainnet validator set."

  validation {
    condition     = var.validator_count == 100
    error_message = "Fem Chain mainnet infrastructure requires exactly 100 validators."
  }
}

variable "regions" {
  type        = list(string)
  default     = ["nyc3", "sfo3", "ams3", "fra1", "sgp1"]
  description = "Five-region placement; confirm account capacity before applying."

  validation {
    condition     = length(var.regions) >= 5
    error_message = "At least five regions are required."
  }
}

variable "droplet_size" {
  type        = string
  default     = "s-2vcpu-4gb"
  description = "Baseline validator size; validate under 100-node test load before production."
}

variable "image" {
  type    = string
  default = "ubuntu-24-04-x64"
}
