#!/bin/sh
# File: initialize.sh (Enhanced)
# Copyright 2022-2025 Korea Battle Simulation Center. All rights reserved.
# SPDX-License-Identifier: MIT
#
# Initialize the Configuration
#

set -euo pipefail

echo "🔧 Initializing Packer RHEL9 Template Build Environment"
echo "========================================================"

follow_link() {
	FILE="$1"
	while [ -h "$FILE" ]; do
		# On Mac OS, readlink -f doesn't work.
		FILE="$(readlink "$FILE")"
	done
	echo "$FILE"
}

SCRIPT_PATH=$(realpath "$(dirname "$(follow_link "$0")")")
CONFIG_PATH=$(realpath "${1:-${SCRIPT_PATH}/rhel8}")

# Install Ansible Galaxy roles
echo "[1/3] Installing Ansible Galaxy roles..."
ansible-galaxy install -r $SCRIPT_PATH/roles/requirements.yml -p $SCRIPT_PATH/roles/

# Create SCAP results directory
echo "[2/3] Creating SCAP results directory..."
mkdir -p scap-results
chmod 755 scap-results

# Initialize Packer plugins (on Internet-connected host only)
# Uncomment on Internet-connected systems
# echo "[3/3] Initializing Packer plugins..."
# packer init -upgrade $SCRIPT_PATH/rhel8
packer init -upgrade \
    -var "vault_address=${VAULT_ADDR:-https://localhost:8200}" \
    -var-file=./common/enclave.pkrvars.hcl \
    -var-file=./common/common.pkrvars.hcl \
    -var-file=./common/linux-storage.pkrvars.hcl \
    -var-file=./common/network.pkrvars.hcl \
    ./rhel9

echo ""
echo "✅ Initialization complete!"
echo ""
echo "Next steps:"
echo "1. Configure Vault authentication (see vault-setup.sh)"
echo "2. Run ./validate.sh to validate configuration"
echo "3. Run ./build.sh to build templates"
