local "build_username" {
  expression = vault("security/data/packer-build", "username")
  sensitive  = true
}

/**
    In order to create the encrypted build password for RHEL, type the following command:

        $ openssl passwd -6

    Follow the prompts to generate the encrypted password.
*/

local "build_password_encrypted" {
  expression = vault("security/data/packer-build", "encrypted_password")
  sensitive  = true
}

local "vsphere_username" {
  expression = vault("security/data/vcenter", "username")
  sensitive  = true
}

local "vsphere_password" {
  expression = vault("security/data/vcenter", "password")
  sensitive  = true
}

local "rhsm_username" {
  expression = vault("security/data/rhsm", "username")
  sensitive  = true
}

local "rhsm_password" {
  expression = vault("security/data/rhsm", "password")
  sensitive  = true
}

local "ansible_username" {
  expression = vault("security/data/ansible", "username")
  sensitive  = true
}

local "ansible_realname" {
  expression = vault("security/data/ansible", "realname")
  sensitive  = true
}

local "ansible_ssh_key" {
  expression = vault("security/data/ansible", "ssh_public_key")
  sensitive  = true
}

local "nessus_username" {
  expression = vault("security/data/nessus", "username")
  sensitive  = true
}

local "nessus_realname" {
  expression = vault("security/data/nessus", "realname")
  sensitive  = true
}

local "nessus_ssh_key" {
  expression = vault("security/data/nessus", "ssh_public_key")
  sensitive  = true
}
