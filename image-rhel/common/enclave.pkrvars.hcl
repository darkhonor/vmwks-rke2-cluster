#####
# Enclave-specific Settings
#####
vault_skip_verify = false

// Removable Media Settings
#iso_url                     = null
iso_path = "/mnt/e/iso"
#iso_web_path = ""

// Ansible Credentials
ansible_private_key = "~/.ssh/sosi_ansible.key"

vault_secrets_mount = "local-kv"
vault_ansible_path  = "ansible"
vault_build_path    = "packer-build"

vm_network_device = "ens192"