# Packer Build of Red Hat Enterprise Linux 9

## Overview

This directory contains Packer templates and configurations for building
automated RHEL 9.6 images using VMware Workstation. The project creates
production-ready images with FIPS compliance and security hardening.

## Directory Structure

- **`common/`** - Shared configuration files for Packer builds
    - `common.pkrvars.hcl` - Common variables used across all builds
    - `linux-storage.pkrvars.hcl` - Linux storage configuration settings
    - `network.pkrvars.hcl` - Network configuration parameters
- **`rhel9/`** - RHEL 9 specific build configurations
    - `rhel9.pkr.hcl` - Main Packer template for RHEL 9 builds
    - `rhel9.auto.pkrvars.hcl` - Auto-generated variables file
    - `variables.pkr.hcl` - Variable definitions for RHEL 9 builds
    - `vault-variables.pkr.hcl` - Vault integration for secrets management
    - `config/` - Configuration templates
        - `ks-server-minimal.pkrtpl.hcl` - Kickstart template for minimal
          server installation
- **`roles/`** - Ansible roles for system configuration
  (see roles/README.md for details)
- **`ansible.cfg`** - Ansible configuration file
- **`build.sh`** - Script to execute Packer build process
- **`format.sh`** - Script to format configuration files
- **`initialize.sh`** - Script to initialize build environment
- **`rhel9-baseline.yml`** - Ansible playbook for baseline RHEL 9
  configuration
- **`rhel9-rke2-baseline.yml`** - Ansible playbook for RHEL 9 with
  RKE2 configuration
- **`validate.sh`** - Script to validate Packer templates before building
- **`.gitignore`** - Git ignore patterns for image builds

:cockroach: **Issues**:

- Too many static values preventing generalization of the script
- Authentication Stuff / Authentication Stuff / and Authentication
  Stuff --- NEED TO MIGRATE OUT

:clipboard: **TODO**:

- [x] Migrate all variables to appropriate pkrvars.hcl files
- [ ] Integrate with Hashicorp Vault to pass secrets
- [x] Create Shell script to kick off validator and builder
- [x] Add Ansible provisioner with STIG and other cleanup actions
- [x] Add STIG settings for VM configuration
- [ ] Need GitLab Pipeline to execute builds

## References

- [Autoinstall Quick Start](https://ubuntu.com/server/docs/install/autoinstall-quickstart)
- [Packer Examples for vSphere](https://https://github.com/vmware-samples/packer-examples-for-vsphere)
- [HashiCorp Packer to Build a Ubuntu 22.04 Image Template in VMware vSphere](https://tekanaid.com/posts/hashicorp-packer-build-ubuntu22-04-vmware)
- [Timeout waiting for SSH for Ubuntu 20.04 LTS Desktop image creation](https://discuss.hashicorp.com/t/timeout-waiting-for-ssh-for-ubuntu-20-04-lts-desktop-image-creation/23175/5)
- [Markdown Basic Formatting Syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
- [Emoji Cheat Sheet](https://github.com/ikatyang/emoji-cheat-sheet/blob/master/README.md)
