# File: rhel9/variables-vault.pkr.hcl
# [STIG-ID V-257777] [NIST SC-12] Cryptographic key management
# [STIG-ID V-257842] [NIST IA-5] Authenticator management
# Vault Version: 1.15+
# Last Updated: 2025-10-02

/*
  DESCRIPTION:
  HashiCorp Vault integration for secure secrets management.
  All credentials are retrieved from external Vault cluster
  
  AUTHENTICATION:
  Set the following environment variables before running Packer:
  - VAULT_ADDR=<Vault URL>
  - VAULT_NAMESPACE=packer/rhel9
  - VAULT_ROLE_ID=<approle-role-id>
  - VAULT_SECRET_ID=<approle-secret-id>
  
  Or use Vault token:
  - VAULT_TOKEN=<vault-token>
*/

# Vault Configuration Variables
variable "vault_address" {
  type        = string
  description = "External Vault cluster address for secrets management"
  default     = "https://localhost:8200"

  validation {
    condition     = can(regex("^https://", var.vault_address))
    error_message = "[STIG-ID V-257777] The Vault address must use the HTTPS protocol for FIPS 140-3 compliance."
  }
}

variable "vault_skip_verify" {
  type        = bool
  description = "Skip TLS certificate verification (NOT recommended for production)"
  default     = false
}

variable "vault_secrets_mount" {
  type        = string
  description = "The mount path for the KV secrets engine in Vault."
  default     = "local-kv"
}

variable "vault_ansible_path" {
  type        = string
  description = "The path to Ansible credentials in the KV secrets engine."
  default     = "ansible"
}

variable "vault_build_path" {
  type        = string
  description = "The path to Build account credentials in the KV secrets engine."
  default     = "packer-build"
}

# # [STIG-ID V-257842] [NIST IA-5] Ansible Service Account Credentials
# local "ansible_username" {
#   expression = vault("${vault_secrets_mount}/data/${vault_ansible_path}", "username")
#   sensitive  = true
# }

# local "ansible_realname" {
#   expression = vault("${vault_secrets_mount}/data/${vault_ansible_path}", "realname")
#   sensitive  = true
# }

# local "ansible_ssh_key" {
#   expression = vault("${vault_secrets_mount}/data/${vault_ansible_path}", "ssh_public_key")
#   sensitive  = true
# }

# # [STIG-ID V-257842] Build Account Credentials (if needed for post-install)
# local "build_username" {
#   expression = vault("${vault_secrets_mount}/data/${vault_build_path}", "username")
#   sensitive  = true
# }

# local "build_password_encrypted" {
#   expression = vault("${vault_secrets_mount}/data/${vault_build_path}", "encrypted_password")
#   sensitive  = true
# }

# [STIG-ID V-257842] [NIST IA-5] Ansible Service Account Credentials
local "ansible_username" {
  expression = vault("local-kv/data/ansible", "username")
  sensitive  = true
}

local "ansible_realname" {
  expression = vault("local-kv/data/ansible", "realname")
  sensitive  = true
}

local "ansible_ssh_key" {
  expression = vault("local-kv/data/ansible", "ssh_public_key")
  sensitive  = true
}

# [STIG-ID V-257842] Build Account Credentials (if needed for post-install)
local "build_username" {
  expression = vault("local-kv/data/packer-build", "username")
  sensitive  = true
}

local "build_password_encrypted" {
  expression = vault("local-kv/data/packer-build", "encrypted_password")
  sensitive  = true
}