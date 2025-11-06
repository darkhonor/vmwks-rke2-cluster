#!/bin/sh
# 
# Script to validate the Packer configuration
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
CONFIG_PATH=$(realpath "${1:-${SCRIPT_PATH}/rhel8}")
COMMON_PATH=$(realpath "${1:-${SCRIPT_PATH}/common}")

echo "Validating RHEL8 Configuration..."
packer validate \
    -var-file=${COMMON_PATH}/common.pkrvars.hcl \
	-var-file=${COMMON_PATH}/enclave.pkrvars.hcl ./rhel8

echo "Validating RHEL9 Configuration..."
packer validate \
    -var-file=${COMMON_PATH}/common.pkrvars.hcl \
	-var-file=${COMMON_PATH}/enclave.pkrvars.hcl ./rhel9

echo "Validating RHEL8 Satellite Server Configuration..."
packer validate \
    -var-file=${COMMON_PATH}/common.pkrvars.hcl \
	-var-file=${COMMON_PATH}/enclave.pkrvars.hcl ./satellite
