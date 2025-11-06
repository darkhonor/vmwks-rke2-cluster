/*
    DESCRIPTION:
    Red Hat Enterprise Linux 8.6 variables used by the Packer Plugin for VMware vSphere (vsphere-iso).
*/

// Virtual Machine Guest Operating System Setting
vm_guest_os_type            = "rhel9_64Guest"
vm_guest_os_family          = "linux"
vm_guest_os_name            = "rhel"
vm_guest_os_version         = "9.3"
vm_guest_hostname           = "rhel9-tmpl"
vm_guest_experience_minimal = "minimal"

// Virtual Machine Hardware Settings
vm_firmware              = "efi-secure"
vm_cdrom_type            = "sata"
vm_cpu_count             = 2
vm_cpu_cores             = 1
vm_cpu_hot_add           = false
vm_mem_size              = 4096
vm_mem_hot_add           = false
vm_disk_size             = 76800
vm_disk_controller_type  = ["pvscsi"]
vm_disk_thin_provisioned = true
vm_network_card          = "vmxnet3"
vm_enable_3d             = false

// Guest Operating System Metadata
vm_guest_os_language = "en_US"
vm_guest_os_keyboard = "us"
vm_guest_os_timezone = "UTC"

// Removable Media Settings
iso_file           = "rhel-9.3-x86_64-dvd.iso"
iso_checksum_type  = "sha256"
iso_checksum_value = "5c802147aa58429b21e223ee60e347e850d6b0d8680930c4ffb27340ffb687a8"

// Boot Settings
vm_boot_order = "disk,cdrom"
vm_boot_wait  = "5s"

// Communicator Settings
communicator_port    = 22
communicator_timeout = "30m"