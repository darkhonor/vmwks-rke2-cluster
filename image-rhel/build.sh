#!/bin/sh
# File: build.sh
# Copyright 2022-2025 Korea Battle Simulation Center. All rights reserved.
# SPDX-License-Identifier: MIT
#
# Build Script
#

follow_link() {
	FILE="$1"
	while [ -h "$FILE" ]; do
		# On Mac OS, readlink -f doesn't work.
		FILE="$(readlink "$FILE")"
	done
	echo "$FILE"
}

SCRIPT_PATH=$(realpath "$(dirname "$(follow_link "$0")")")
CONFIG_8_PATH=$(realpath "${1:-${SCRIPT_PATH}/rhel8}")
CONFIG_9_PATH=$(realpath "${1:-${SCRIPT_PATH}/rhel9}")
COMMON_PATH=$(realpath "${1:-${SCRIPT_PATH}/common}")

echo "Building Red Hat Enterprise Linux Linux 9 Template"
packer build -force -on-error=ask \
    -var-file=${COMMON_PATH}/enclave.pkrvars.hcl \
    -var-file=${COMMON_PATH}/common.pkrvars.hcl \
    -var-file=${COMMON_PATH}/linux-storage.pkrvars.hcl \
    -var-file=${COMMON_PATH}/network.pkrvars.hcl \
    ./rhel9/
