# RHEL 9 Build Configuration

This directory contains all Packer templates and configuration files
specific to building RHEL 9.6 images with VMware Workstation.

## Directory Contents

- **`rhel9.pkr.hcl`** - Main Packer template defining the build process,
  builders, provisioners, and post-processors for RHEL 9 images
- **`rhel9.auto.pkrvars.hcl`** - Auto-generated variables file created
  during the build process with dynamic values
- **`variables.pkr.hcl`** - Variable definitions for RHEL 9 builds including
  input types, descriptions, and default values
- **`vault-variables.pkr.hcl`** - Vault integration configuration for
  securely retrieving secrets and sensitive data during builds
- **`config/`** - Configuration templates directory
    - `ks-server-minimal.pkrtpl.hcl` - Kickstart template for automated
      minimal RHEL 9 server installation with pre-configured system settings
