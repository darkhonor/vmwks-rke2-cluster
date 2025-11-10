/*
    DESCRIPTION:
    Common variables used for all builds.
    - Variables are use by the source blocks.
*/

// Virtual Machine Settings
# VM Version 21 is for ESXi 8.0 Update 2
# VM Version 19 is for ESXi 7.0 Update 2
# VM Version 17 is for ESXi 7.0
## The following are included in case you need, but are no longer VMware supported vSphere versions
# VM Version 15 is for ESXi 6.7 Update 2 or later
# VM Version 14 is for ESXi 6.7
common_vm_version           = 19
common_tools_upgrade_policy = true
common_remove_cdrom         = true

// OVF Export Settings
common_ovf_export_enabled   = false
common_ovf_export_overwrite = true

// Boot and Provisioning Settings
common_data_source       = "disk"
common_http_ip           = null
common_http_port_min     = 8000
common_http_port_max     = 8099
common_ip_wait_timeout   = "45m"
common_ip_settle_timeout = "1m"
common_shutdown_timeout  = "15m"
