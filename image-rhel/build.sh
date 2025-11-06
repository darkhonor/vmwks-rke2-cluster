#!/bin/sh
# Build Script
#
# /usr/bin/ssh-keygen -f ~/.ssh/known_hosts -R 192.168.60.25

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

##
# Build RHEL VM Templates
##
### Build RHEL 8 VM Template
# echo "Building RHEL 8 Template"
# packer build -force -on-error=ask \
# 		-var-file=${COMMON_PATH}/enclave.pkrvars.hcl \
# 		-var-file=${COMMON_PATH}/common.pkrvars.hcl rhel8/

### Build RHEL 9 VM Template
echo "Building RHEL 9 Template"
packer build -force -on-error=ask \
		-var-file=${COMMON_PATH}/enclave.pkrvars.hcl \
		-var-file=${COMMON_PATH}/common.pkrvars.hcl rhel9/

### Build RHEL 8 Satellite Server VM Template
# echo "Building RHEL 8 Satellite Server Template"
# packer build -force -on-error=ask \
# 		-var-file=${COMMON_PATH}/enclave.pkrvars.hcl \
# 		-var-file=${COMMON_PATH}/common.pkrvars.hcl satellite/
