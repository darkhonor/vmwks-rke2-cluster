//  BLOCK: packer
//  The Packer configuration.
packer {
  required_plugins {
    vsphere = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

//  BLOCK: locals
//  Defines the local variables.
locals {
  build_by          = "Built by: HashiCorp Packer ${packer.version}"
  build_date        = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version     = formatdate("YY.MM", timestamp())
  build_description = "Version: v${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}"
  iso_paths         = ["[${var.common_iso_datastore}] ${var.iso_path}/${var.iso_file}"]
  iso_checksum      = "${var.iso_checksum_type}:${var.iso_checksum_value}"
  server_minimal_source_content = {
    "/ks.cfg" = templatefile("${abspath(path.root)}/config/ks-server-minimal.pkrtpl.hcl", {
      builder_username     = local.build_username
      builder_password     = local.build_password_encrypted
      rhn_username         = local.rhsm_username
      rhn_password         = local.rhsm_password
      ansible_username     = local.ansible_username
      ansible_key          = local.ansible_ssh_key
      nessus_username      = local.nessus_username
      nessus_key           = local.nessus_ssh_key
      vm_guest_hostname    = var.vm_guest_hostname
      vm_guest_os_language = var.vm_guest_os_language
      vm_guest_os_keyboard = var.vm_guest_os_keyboard
    vm_guest_os_timezone = var.vm_guest_os_timezone })
  }

  data_source_command    = var.common_data_source == "http" ? "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg" : "inst.ks=cdrom:/ks.cfg"
  vm_server_minimal_name = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_experience_minimal}-v${local.build_version}"
  vm_server_rke2_name    = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-rke2-v${local.build_version}"
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "vsphere-iso" "linux-rhel-server-minimal" {
  // vCenter Connection 
  vcenter_server      = var.vsphere_server
  username            = local.vsphere_username
  password            = local.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  // vSphere Settings
  datacenter = var.vsphere_datacenter
  cluster    = var.vsphere_cluster
  datastore  = var.vsphere_datastore
  folder     = var.vsphere_folder
  host       = var.vsphere_host

  // Virtual Machine Settings
  vm_name              = local.vm_server_minimal_name
  guest_os_type        = var.vm_guest_os_type
  firmware             = var.vm_firmware
  CPUs                 = var.vm_cpu_count
  cpu_cores            = var.vm_cpu_cores
  RAM                  = var.vm_mem_size
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
  ip_wait_timeout   = var.common_ip_wait_timeout
  ip_settle_timeout = var.common_ip_settle_timeout
  notes             = local.build_description


  // Removable Media Settings
  iso_url      = var.iso_url
  iso_paths    = local.iso_paths
  iso_checksum = local.iso_checksum
  http_content = var.common_data_source == "http" ? local.server_minimal_source_content : null
  cd_content   = var.common_data_source == "disk" ? local.server_minimal_source_content : null
  cd_label     = var.common_data_source == "disk" ? "cidata" : null

  // Boot and Provisioning Settings
  boot_order    = var.vm_boot_order
  boot_wait     = var.vm_boot_wait
  http_ip       = var.common_data_source == "http" ? var.common_http_ip : null
  http_port_min = var.common_data_source == "http" ? var.common_http_port_min : null
  http_port_max = var.common_data_source == "http" ? var.common_http_port_max : null
  boot_command = [
    "<up>",
    "e",
    "<down><down><end><wait>",
    " fips=1 inst.sshd inst.text ${local.data_source_command}",
    "<enter><wait><leftCtrlOn>x<leftCtrlOff>"
  ]

  shutdown_command = "sudo -S -E shutdown -P now"
  shutdown_timeout = var.common_shutdown_timeout

  // Communicator Settings
  communicator         = "ssh"
  ssh_username         = local.ansible_username
  ssh_port             = var.communicator_port
  ssh_timeout          = var.communicator_timeout
  ssh_private_key_file = var.ansible_private_key

  // Template Settings
  convert_to_template = var.common_template_conversion
}

source "vsphere-iso" "linux-rhel-server-rke2" {
  // vCenter Connection 
  vcenter_server      = var.vsphere_server
  username            = local.vsphere_username
  password            = local.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  // vSphere Settings
  datacenter = var.vsphere_datacenter
  cluster    = var.vsphere_cluster
  datastore  = var.vsphere_datastore
  folder     = var.vsphere_folder
  host       = var.vsphere_host

  // Virtual Machine Settings
  vm_name              = local.vm_server_rke2_name
  guest_os_type        = var.vm_guest_os_type
  firmware             = var.vm_firmware
  CPUs                 = var.vm_cpu_count
  cpu_cores            = var.vm_cpu_cores
  RAM                  = var.vm_mem_size
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
  ip_wait_timeout   = var.common_ip_wait_timeout
  ip_settle_timeout = var.common_ip_settle_timeout
  notes             = local.build_description


  // Removable Media Settings
  iso_url      = var.iso_url
  iso_paths    = local.iso_paths
  iso_checksum = local.iso_checksum
  http_content = var.common_data_source == "http" ? local.server_minimal_source_content : null
  cd_content   = var.common_data_source == "disk" ? local.server_minimal_source_content : null
  cd_label     = var.common_data_source == "disk" ? "cidata" : null

  // Boot and Provisioning Settings
  boot_order    = var.vm_boot_order
  boot_wait     = var.vm_boot_wait
  http_ip       = var.common_data_source == "http" ? var.common_http_ip : null
  http_port_min = var.common_data_source == "http" ? var.common_http_port_min : null
  http_port_max = var.common_data_source == "http" ? var.common_http_port_max : null
  boot_command = [
    "<up>",
    "e",
    "<down><down><end><wait>",
    " fips=1 inst.sshd inst.text ${local.data_source_command}",
    "<enter><wait><leftCtrlOn>x<leftCtrlOff>"
  ]

  shutdown_command = "sudo -S -E shutdown -P now"
  shutdown_timeout = var.common_shutdown_timeout

  // Communicator Settings
  communicator         = "ssh"
  ssh_username         = local.ansible_username
  ssh_port             = var.communicator_port
  ssh_timeout          = var.communicator_timeout
  ssh_private_key_file = var.ansible_private_key

  // Template Settings
  convert_to_template = var.common_template_conversion
}

build {
  sources = [
    "source.vsphere-iso.linux-rhel-server-minimal",
    "source.vsphere-iso.linux-rhel-server-rke2"
  ]

  provisioner "ansible" {

    # Required to limit for VM STIG'ing
    only          = ["vsphere-iso.linux-rhel-server-minimal"]
    playbook_file = "./rhel9-baseline.yml"
    roles_path    = "./roles"
    use_proxy     = false
    user          = local.ansible_username
    ansible_env_vars = [
      "ANSIBLE_CONFIG=./ansible.cfg"
    ]
    extra_arguments = [
      "--extra-vars", "vcenter_hostname=${var.vsphere_server}",
      "--extra-vars", "myrhsm_username=${local.rhsm_username}",
      "--extra-vars", "myrhsm_password=${local.rhsm_password}",
      "--extra-vars", "vcenter_validate_certs=${var.vsphere_validate_certificate}",
      "--extra-vars", "Template_Name=${local.vm_server_minimal_name}",
      "--extra-vars", "Template_3D_Enabled=${var.vm_enable_3d}"
    ]
  }

    provisioner "ansible" {

    # Required to limit for VM STIG'ing
    only          = ["vsphere-iso.linux-rhel-server-rke2"]
    playbook_file = "./rhel9-rke2-baseline.yml"
    roles_path    = "./roles"
    use_proxy     = false
    user          = local.ansible_username
    ansible_env_vars = [
      "ANSIBLE_CONFIG=./ansible.cfg"
    ]
    extra_arguments = [
      "--extra-vars", "vcenter_hostname=${var.vsphere_server}",
      "--extra-vars", "myrhsm_username=${local.rhsm_username}",
      "--extra-vars", "myrhsm_password=${local.rhsm_password}",
      "--extra-vars", "vcenter_validate_certs=${var.vsphere_validate_certificate}",
      "--extra-vars", "Template_Name=${local.vm_server_minimal_name}",
      "--extra-vars", "Template_3D_Enabled=${var.vm_enable_3d}"
    ]
  }
}
