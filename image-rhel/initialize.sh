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
CONFIG_PATH=$(realpath "${1:-${SCRIPT_PATH}/rhel8}")

##
# Initialize Build Environment
##
# Download Required Ansible Roles prior to the build
ansible-galaxy install -r $SCRIPT_PATH/roles/requirements.yml -p $SCRIPT_PATH/roles/ --ignore-errors

# Initialize Packer Plugins
packer init -upgrade $SCRIPT_PATH/rhel8
packer init -upgrade $SCRIPT_PATH/rhel9
packer init -upgrade $SCRIPT_PATH/satellite