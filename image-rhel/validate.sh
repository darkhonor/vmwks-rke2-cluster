#!/bin/sh
# File: validate.sh (Enhanced)
# Copyright 2022-2025 Korea Battle Simulation Center. All rights reserved.
# SPDX-License-Identifier: MIT
# 
# Script to validate the Packer configuration
#

set -euo pipefail

echo "🔍 Validating Red Hat Enterprise Linux 9 Template Configuration"
echo "================================================================"

# Validate Vault connectivity
echo "[1/3] Validating Vault connectivity..."
if [[ -z "${VAULT_ADDR:-}" ]]; then
    echo "⚠️  WARNING: VAULT_ADDR not set"
    echo "   Set: export VAULT_ADDR=https://localhost:8200"
else
    if vault status >/dev/null 2>&1; then
        echo "✅ Vault connectivity validated"
    else
        echo "❌ Error: Cannot connect to Vault"
        exit 1
    fi
fi

# Validate Packer configuration
echo "[2/3] Validating Packer configuration..."
packer validate \
    -var "vault_address=${VAULT_ADDR:-https://localhost:8200}" \
    -var-file=./common/enclave.pkrvars.hcl \
    -var-file=./common/common.pkrvars.hcl \
    -var-file=./common/linux-storage.pkrvars.hcl \
    -var-file=./common/network.pkrvars.hcl \
    ./rhel9/

if [ $? -eq 0 ]; then
    echo "✅ Packer configuration is valid"
else
    echo "❌ Packer configuration validation failed"
    exit 1
fi

# Validate Ansible playbooks
echo "[3/3] Validating Ansible playbooks..."
ansible-playbook --syntax-check rhel9-baseline.yml
ansible-playbook --syntax-check rhel9-ws.yml

echo ""
echo "✅ All validations passed!"
