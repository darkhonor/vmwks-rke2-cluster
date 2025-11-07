# File: rhel9/linux-rhel.pkr.hcl (Enhanced)
# Copyright 2022-2025 Korea Battle Simulation Center. All rights reserved.
# SPDX-License-Identifier: MIT

/*
    DESCRIPTION:
    Red Hat Enterprise Linux 9 STIG-compliant build definition.
    Packer Plugin for VMware vSphere: 'vsphere-iso' builder.
    
    COMPLIANCE:
    - DISA RHEL 9 STIG V2R1
    - NIST SP 800-53 Rev 5
    - DoD Enterprise DevSecOps Initiative
    - FIPS 140-3
    
    SECURITY CONTROLS:
    - SCAP hardening applied during kickstart
    - FIPS mode enforced
    - SELinux enforcing
    - AIDE file integrity monitoring
    - USBGuard device control
    - Audit logging enabled
*/

//  BLOCK: packer
//  The Packer configuration.

packer {
  required_version = ">= 1.14.0"
  required_plugins {
    # https://developer.hashicorp.com/packer/integrations/hashicorp/vsphere/latest/components/builder/vsphere-iso
    vsphere = {
      source  = "github.com/hashicorp/vsphere"
      version = ">= 2.0.0"
    }
    # https://developer.hashicorp.com/packer/integrations/hashicorp/ansible
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.4"
    }
  }
}

//  BLOCK: locals
//  Defines the local variables.

locals {
  build_by          = "Built by: HashiCorp Packer ${packer.version}"
  build_date        = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version     = formatdate("YY.MM", timestamp())
  
  # [STIG-ID V-257777] [NIST CM-6] Build metadata with compliance information
  build_description = &lt;&lt;-EOT
    Red Hat Enterprise Linux 9.6 STIG-Compliant Template
    
    Version: ${local.build_version}
    Built on: ${local.build_date}
    ${local.build_by}
    
    Compliance:
    - DISA RHEL 9 STIG V2R1
    - NIST SP 800-53 Rev 5
    - FIPS 140-3 Mode: Enabled
    - SELinux: Enforcing
    - SCAP Profile: xccdf_org.ssgproject.content_profile_stig
    
    Security Controls:
    - File Integrity: AIDE initialized
    - Device Control: USBGuard configured
    - Audit Logging: Enabled
    - Remote Logging: Configured
    - Time Sync: Chrony (DoD NTP)
    
    Service Accounts:
    - ansible (automation)
    - nessus (vulnerability scanning)
  EOT
  
  iso_paths         = ["[${var.common_iso_datastore}] ${var.iso_path}/${var.iso_file}"]

  manifest_date   = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path   = "${path.cwd}/manifests/"
  manifest_output = "${local.manifest_path}${local.manifest_date}.json"
  data_source_content_min = {
    "/ks.cfg" = templatefile("${abspath(path.root)}/config/ks.pkrtpl.hcl", {
      ansible_username      = local.ansible_username
      ansible_key           = local.ansible_ssh_key
      nessus_username       = local.nessus_username
      nessus_key            = local.nessus_ssh_key
      vm_guest_os_language  = var.vm_guest_os_language
      vm_guest_os_keyboard  = var.vm_guest_os_keyboard
      vm_guest_os_timezone  = var.vm_guest_os_timezone
      vm_guest_os_cloudinit = var.vm_guest_os_cloudinit
      network = templatefile("${abspath(path.root)}/config/network.pkrtpl.hcl", {
        device  = var.vm_network_device
        ip      = var.vm_ip_address
        netmask = var.vm_ip_netmask
        gateway = var.vm_ip_gateway
        dns     = var.vm_dns_list
      })
      storage = templatefile("${abspath(path.root)}/config/storage.pkrtpl.hcl", {
        device     = var.vm_disk_device
        swap       = var.vm_disk_use_swap
        partitions = var.vm_disk_partitions
        lvm        = var.vm_disk_lvm
      })
      additional_packages = join(" ", var.additional_packages)
    })
  }
  data_source_content_ws = {
    "/ks.cfg" = templatefile("${abspath(path.root)}/config/ks-ws.pkrtpl.hcl", {
      ansible_username      = local.ansible_username
      ansible_key           = local.ansible_ssh_key
      nessus_username       = local.nessus_username
      nessus_key            = local.nessus_ssh_key
      vm_guest_os_language  = var.vm_guest_os_language
      vm_guest_os_keyboard  = var.vm_guest_os_keyboard
      vm_guest_os_timezone  = var.vm_guest_os_timezone
      vm_guest_os_cloudinit = var.vm_guest_os_cloudinit
      network = templatefile("${abspath(path.root)}/config/network.pkrtpl.hcl", {
        device  = var.vm_network_device
        ip      = var.vm_ip_address
        netmask = var.vm_ip_netmask
        gateway = var.vm_ip_gateway
        dns     = var.vm_dns_list
      })
      storage = templatefile("${abspath(path.root)}/config/storage.pkrtpl.hcl", {
        device     = var.vm_disk_device
        swap       = var.vm_disk_use_swap
        partitions = var.vm_disk_partitions
        lvm        = var.vm_disk_lvm_ws
      })
      additional_packages = join(" ", var.additional_packages)
    })
  }
  http_ks_command = "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg"
  http_ks_command_with_ip = format(
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg ip=%s::%s:%s:hostname:%s:none",
    var.vm_ip_address != null ? var.vm_ip_address : "",
    var.vm_ip_gateway != null ? var.vm_ip_gateway : "",
    var.vm_ip_netmask != null ? var.vm_ip_netmask : "",
    var.vm_network_device
  )
  # [STIG-ID V-257777] Boot command without SSH during installation
  data_source_command = var.common_data_source == "http" ? "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg" : "inst.ks=cdrom:/ks.cfg"

  # VM naming convention
  vm_name_min         = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-minimal-${local.build_version}"
  vm_name_ws          = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-ws-${local.build_version}"
  bucket_name         = replace("${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}", ".", "")
  bucket_description  = "${var.vm_guest_os_family} ${var.vm_guest_os_name} ${var.vm_guest_os_version}"
}

//  BLOCK: source
//  Defines the builder configuration blocks.

source "vsphere-iso" "linux-rhel-minimal" {

  # vCenter Server Endpoint Settings and Credentials
  # [STIG-ID V-257777] [NIST SC-12] Credentials from Vault
  vcenter_server      = var.vsphere_server
  username            = local.vsphere_username
  password            = local.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  // vSphere Settings
  datacenter                     = var.vsphere_datacenter
  cluster                        = var.vsphere_cluster
  host                           = var.vsphere_host
  datastore                      = var.vsphere_datastore
  folder                         = var.vsphere_folder
  resource_pool                  = var.vsphere_resource_pool
  set_host_for_datastore_uploads = var.vsphere_set_host_for_datastore_uploads

  // Virtual Machine Settings
  vm_name              = local.vm_name_min
  guest_os_type        = var.vm_guest_os_type
  firmware             = var.vm_firmware
  CPUs                 = var.vm_cpu_count
  cpu_cores            = var.vm_cpu_cores
  CPU_hot_plug         = var.vm_cpu_hot_add
  RAM                  = var.vm_mem_size
  RAM_hot_plug         = var.vm_mem_hot_add
  cdrom_type           = var.vm_cdrom_type
  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin_provisioned
  }
  network_adapters {
    network      = var.vsphere_network
    network_card = var.vm_network_card
  }
  vm_version           = var.common_vm_version
  remove_cdrom         = var.common_remove_cdrom
  reattach_cdroms      = var.vm_cdrom_count
  tools_upgrade_policy = var.common_tools_upgrade_policy
  notes                = local.build_description

  // Removable Media Settings
  iso_paths    = local.iso_paths
  http_content = var.common_data_source == "http" ? local.data_source_content_min : null
  cd_content   = var.common_data_source == "disk" ? local.data_source_content_min : null

  # Boot and Provisioning Settings
  # [STIG-ID V-257777] [NIST SC-13] Secure boot with FIPS, SELinux, and audit
  http_ip       = var.common_data_source == "http" ? var.common_http_ip : null
  http_port_min = var.common_data_source == "http" ? var.common_http_port_min : null
  http_port_max = var.common_data_source == "http" ? var.common_http_port_max : null
  boot_order    = var.vm_boot_order
  boot_wait     = var.vm_boot_wait
  boot_command = [
    "<up>",
    "e",
    "<down><down><end><wait>",
    # Enable FIPS mode, SELinux enforcing, and audit logging
    # Remove inst.sshd to prevent SSH access during installation
    " fips=1 inst.text selinux=1 enforcing=1 audit=1 ${local.data_source_command}",
    "<enter><wait><leftCtrlOn>x<leftCtrlOff>"
  ]
  ip_wait_timeout   = var.common_ip_wait_timeout
  ip_settle_timeout = var.common_ip_settle_timeout
  shutdown_command  = "sudo -S -E shutdown -P now"
  shutdown_timeout  = var.common_shutdown_timeout

  # Communicator Settings and Credentials
  # [STIG-ID V-257842] [NIST IA-5] SSH key-based authentication
  communicator         = "ssh"
  ssh_proxy_host       = var.communicator_proxy_host
  ssh_proxy_port       = var.communicator_proxy_port
  ssh_proxy_username   = var.communicator_proxy_username
  ssh_proxy_password   = var.communicator_proxy_password
  ssh_username         = local.ansible_username
  ssh_private_key_file = var.ansible_private_key
  ssh_port             = var.communicator_port
  ssh_timeout          = var.communicator_timeout

  // Template and Content Library Settings
  convert_to_template = var.common_template_conversion
  dynamic "content_library_destination" {
    for_each = var.common_content_library_name != null ? [1] : []
    content {
      library     = var.common_content_library
      description = local.build_description
      ovf         = var.common_content_library_ovf
      destroy     = var.common_content_library_destroy
      skip_import = var.common_content_library_skip_export
    }
  }
}

source "vsphere-iso" "linux-rhel-ws" {

  # vCenter Server Endpoint Settings and Credentials
  # [STIG-ID V-257777] [NIST SC-12] Credentials from Vault
  vcenter_server      = var.vsphere_server
  username            = local.vsphere_username
  password            = local.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  // vSphere Settings
  datacenter                     = var.vsphere_datacenter
  cluster                        = var.vsphere_cluster
  host                           = var.vsphere_host
  datastore                      = var.vsphere_datastore
  folder                         = var.vsphere_folder
  resource_pool                  = var.vsphere_resource_pool
  set_host_for_datastore_uploads = var.vsphere_set_host_for_datastore_uploads

  // Virtual Machine Settings
  vm_name              = local.vm_name_ws
  guest_os_type        = var.vm_guest_os_type
  firmware             = var.vm_firmware
  CPUs                 = var.vm_cpu_count
  cpu_cores            = var.vm_cpu_cores
  CPU_hot_plug         = var.vm_cpu_hot_add
  RAM                  = var.vm_mem_size
  RAM_hot_plug         = var.vm_mem_hot_add
  cdrom_type           = var.vm_cdrom_type
  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin_provisioned
  }
  network_adapters {
    network      = var.vsphere_network
    network_card = var.vm_network_card
  }
  vm_version           = var.common_vm_version
  remove_cdrom         = var.common_remove_cdrom
  reattach_cdroms      = var.vm_cdrom_count
  tools_upgrade_policy = var.common_tools_upgrade_policy
  notes                = local.build_description

  // Removable Media Settings
  iso_paths    = local.iso_paths
  http_content = var.common_data_source == "http" ? local.data_source_content_ws : null
  cd_content   = var.common_data_source == "disk" ? local.data_source_content_ws : null

  # Boot and Provisioning Settings
  # [STIG-ID V-257777] [NIST SC-13] Secure boot with FIPS, SELinux, and audit
  http_ip       = var.common_data_source == "http" ? var.common_http_ip : null
  http_port_min = var.common_data_source == "http" ? var.common_http_port_min : null
  http_port_max = var.common_data_source == "http" ? var.common_http_port_max : null
  boot_order    = var.vm_boot_order
  boot_wait     = var.vm_boot_wait
  boot_command = [
    "<up>",
    "e",
    "<down><down><end><wait>",
    # Enable FIPS mode, SELinux enforcing, and audit logging
    # Remove inst.sshd to prevent SSH access during installation
    " fips=1 inst.text selinux=1 enforcing=1 audit=1 ${local.data_source_command}",
    "<enter><wait><leftCtrlOn>x<leftCtrlOff>"
  ]
  ip_wait_timeout   = var.common_ip_wait_timeout
  ip_settle_timeout = var.common_ip_settle_timeout
  shutdown_command  = "sudo -S -E shutdown -P now"
  shutdown_timeout  = var.common_shutdown_timeout

  # Communicator Settings and Credentials
  # [STIG-ID V-257842] [NIST IA-5] SSH key-based authentication
  communicator         = "ssh"
  ssh_proxy_host       = var.communicator_proxy_host
  ssh_proxy_port       = var.communicator_proxy_port
  ssh_proxy_username   = var.communicator_proxy_username
  ssh_proxy_password   = var.communicator_proxy_password
  ssh_username         = local.ansible_username
  ssh_private_key_file = var.ansible_private_key
  ssh_port             = var.communicator_port
  ssh_timeout          = var.communicator_timeout

  // Template and Content Library Settings
  convert_to_template = var.common_template_conversion
  dynamic "content_library_destination" {
    for_each = var.common_content_library_name != null ? [1] : []
    content {
      library     = var.common_content_library
      description = local.build_description
      ovf         = var.common_content_library_ovf
      destroy     = var.common_content_library_destroy
      skip_import = var.common_content_library_skip_export
    }
  }
}

//  BLOCK: build
//  Defines the builders to run, provisioners, and post-processors.

build {
  sources = [
    "source.vsphere-iso.linux-rhel-minimal",
    "source.vsphere-iso.linux-rhel-ws"
  ]

  # [STIG-ID V-257849] Post-SCAP Ansible configuration
  provisioner "ansible" {
    only                   = ["vsphere-iso.linux-rhel-minimal"]
    user                   = local.ansible_username
    galaxy_file            = "${path.cwd}/roles/requirements.yml"
    galaxy_force_with_deps = true
    playbook_file          = "${path.cwd}/rhel9-baseline.yml"
    roles_path             = "${path.cwd}/roles"
    ansible_env_vars = [
      "ANSIBLE_CONFIG=${path.cwd}/ansible.cfg",
      "ANSIBLE_PYTHON_INTERPRETER=/usr/libexec/platform-python"
    ]
    extra_arguments = [
      "--extra-vars",
      "ansible_become_pass=''"
    ]
  }

  # [STIG-ID V-257849] Post-SCAP Ansible configuration
  provisioner "ansible" {
    only                   = ["vsphere-iso.linux-rhel-ws"]
    user                   = local.ansible_username
    galaxy_file            = "${path.cwd}/roles/requirements.yml"
    galaxy_force_with_deps = true
    playbook_file          = "${path.cwd}/rhel9-ws.yml"
    roles_path             = "${path.cwd}/roles"
    ansible_env_vars = [
      "ANSIBLE_CONFIG=${path.cwd}/ansible.cfg",
      "ANSIBLE_PYTHON_INTERPRETER=/usr/libexec/platform-python"
    ]
    extra_arguments = [
      "--extra-vars",
      "ansible_become_pass=''"
    ]
  }

  # [STIG-ID V-257849] Build manifest with compliance metadata
  post-processor "manifest" {
    output     = local.manifest_output
    strip_path = true
    strip_time = true
    custom_data = {
      ansible_username         = local.ansible_username
      build_date               = local.build_date
      build_version            = local.build_version
      common_data_source       = var.common_data_source
      common_vm_version        = var.common_vm_version
      vm_cpu_cores             = var.vm_cpu_cores
      vm_cpu_count             = var.vm_cpu_count
      vm_disk_size             = var.vm_disk_size
      vm_disk_thin_provisioned = var.vm_disk_thin_provisioned
      vm_firmware              = var.vm_firmware
      vm_guest_os_type         = var.vm_guest_os_type
      vm_mem_size              = var.vm_mem_size
      vm_network_card          = var.vm_network_card
      vsphere_cluster          = var.vsphere_cluster
      vsphere_datacenter       = var.vsphere_datacenter
      vsphere_datastore        = var.vsphere_datastore
      vsphere_endpoint         = var.vsphere_server
      vsphere_folder           = var.vsphere_folder
      # Compliance metadata
      stig_profile             = "xccdf_org.ssgproject.content_profile_stig"
      fips_mode                = "enabled"
      selinux_mode             = "enforcing"
      aide_initialized         = "true"
      usbguard_configured      = "true"
    }
  }
}
