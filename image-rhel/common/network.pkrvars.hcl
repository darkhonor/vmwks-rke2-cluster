# File: common/network.pkrvars.hcl
# Copyright 2022-2025 Korea Battle Simulation Center. All rights reserved.
# SPDX-License-Identifier: MIT

/*
    DESCRIPTION:
    Network variables used for all builds.
    - Variables are passed to and used by guest operating system configuration files (e.g., ks.cfg).

*/

// VM Network Settings (default DHCP)
vm_ip_address = null
vm_ip_netmask = null
vm_ip_gateway = null
vm_dns_list   = ["192.168.51.65"]
