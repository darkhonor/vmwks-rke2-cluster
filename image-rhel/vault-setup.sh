#!/bin/bash
# File: vault-setup.sh
# Copyright 2022-2025 Korea Battle Simulation Center. All rights reserved.
# SPDX-License-Identifier: MIT
#
# [STIG-ID V-257842] [NIST IA-5] Authenticator management
# Vault Setup Script for Packer Templates
# Vault Version: 1.15+
# Compliance: DoD Enterprise DevSecOps Initiative

set -euo pipefail

export VAULT_ADDR=https://vault.kten.mil
export VAULT_AUTH_APPROLE_PATH=packer
export VAULT_KV_STORE_PATH=SysAd
export VAULT_ROLE_NAME=packer

echo "🔐 Setting up Vault for Packer Templates"
echo "=============================================="

# 1. Enable AppRole authentication (if not already enabled)
echo "[1/6] Enabling AppRole authentication..."
vault auth enable -path=$VAULT_AUTH_APPROLE_PATH approle 2>/dev/null || echo "AppRole at $VAULT_AUTH_APPROLE_PATH already enabled"

# 2. Enable KV-V2 secrets engine for Packer
echo "[2/6] Enabling KV-V2 secrets engine..."
vault secrets enable -path=$VAULT_KV_STORE_PATH kv-v2 2>/dev/null || echo "KV-V2 $VAULT_KV_STORE_PATH already enabled"

# 3. Create Vault policy for Packer
echo "[3/6] Creating Vault policy..."
vault policy write $VAULT_ROLE_NAME-policy - <<EOF
# [NIST AC-6] Least Privilege
# [NIST AC-3] Access Enforcement
# Packer Template Build Policy

# vSphere credentials
path "$VAULT_KV_STORE_PATH/data/VMware" {
  capabilities = ["read", "list"]
}

# Ansible service account
path "$VAULT_KV_STORE_PATH/data/ansible" {
  capabilities = ["read", "list"]
}

# Nessus (ACAS) service account
path "$VAULT_KV_STORE_PATH/data/nessus" {
  capabilities = ["read", "list"]
}

# Build account credentials
path "$VAULT_KV_STORE_PATH/data/packer-build" {
  capabilities = ["read", "list"]
}

# Metadata access
path "$VAULT_KV_STORE_PATH/metadata/*" {
  capabilities = ["read", "list"]
}

# Deny all other paths
path "*" {
  capabilities = ["deny"]
}
EOF

# 4. Create AppRole for Packer
echo "[4/6] Creating AppRole for Packer..."
vault write auth/$VAULT_AUTH_APPROLE_PATH/role/$VAULT_ROLE_NAME \
    token_policies="$VAULT_ROLE_NAME-policy" \
    token_ttl=2h \
    token_max_ttl=4h \
    secret_id_ttl=24h \
    secret_id_num_uses=10

# 5. Get Role ID and Secret ID
echo "[5/6] Retrieving AppRole credentials..."
ROLE_ID=$(vault read -field=role_id auth/$VAULT_AUTH_APPROLE_PATH/role/$VAULT_ROLE_NAME/role-id)
SECRET_ID=$(vault write -field=secret_id -f auth/$VAULT_AUTH_APPROLE_PATH/role/$VAULT_ROLE_NAME/secret-id)

echo ""
echo "✅ Vault setup complete!"
echo ""
echo "📋 Set these environment variables before running Packer:"
echo "export VAULT_ADDR=${VAULT_ADDR}"
echo "export VAULT_ROLE_ID=${ROLE_ID}"
echo "export VAULT_SECRET_ID=${SECRET_ID}"
echo ""

# 6. Store credentials in Vault (example - replace with actual values)
echo "[6/6] Example: Storing credentials in Vault..."
cat <<EXAMPLE

# Store vSphere credentials:
vault kv put $VAULT_KV_STORE_PATH/VMware \\
    terraform_username="svc-packer@vsphere.local" \\
    terraform_password="<secure-password>"

# Store Ansible service account:
vault kv put $VAULT_KV_STORE_PATH/ansible \\
    username="ansible" \\
    realname="Ansible Automation" \\
    ssh_public_key="ssh-rsa AAAAB3NzaC1yc2E..."

# Store Nessus service account:
vault kv put $VAULT_KV_STORE_PATH/nessus \\
    username="nessus" \\
    realname="Nessus Scanner" \\
    ssh_public_key="ssh-rsa AAAAB3NzaC1yc2E..."

# Store build account:
vault kv put $VAULT_KV_STORE_PATH/packer-build \\
    username="packer" \\
    encrypted_password="\$6\$rounds=5000\$..."
EXAMPLE
