#####
# Enclave-specific Settings
#####
vault_skip_verify = false

// Removable Media Settings
# common_iso_datastore        = "HarvesterNAS"
common_iso_datastore        = "DESX2-Datastore"
common_content_library_name = "TrueNAS_Library"
#iso_url                     = null
iso_path = "/mnt/e/iso"
#iso_web_path = ""

// Ansible Credentials
ansible_private_key = "~/.ssh/id_aackerman-2024.key"

kv_secrets_mount = "local-kv"
kv_ansible_path  = "ansible"
kv_build_path    = "packer-build"
