# Ansible Roles for RHEL Image Builds

This directory contains the Ansible roles used in the Packer builds for
creating RHEL images. The roles are managed through the `requirements.yml`
file and are sourced from external repositories.

## Available Roles

### dns_client

Configures DNS client settings on the target system. This role sets up DNS
servers and search domains to ensure proper name resolution.

**Usage in builds:**

- Configures primary and secondary DNS servers
- Sets search domain for network resolution
- Used in all baseline builds (RHEL 8, RHEL 9, and RKE2)

### firefox_stig

Applies Security Technical Implementation Guide (STIG) hardening settings
specifically for Firefox browser. This role ensures Firefox meets security
compliance requirements.

**Usage in builds:**

- Optional role for desktop configurations
- Implements DISA STIG requirements for Firefox
- Used when creating desktop-oriented images

### system_base

Provides base system configuration and setup for RHEL systems. This is a
foundational role that handles core system initialization.

**Usage in builds:**

- Configures Red Hat Subscription Manager (RHSM) registration
- Sets up basic system packages and repositories
- Handles network connectivity configuration
- Used in all baseline builds

### system_clean

Performs system cleanup operations after image configuration is complete. This
role removes temporary files, caches, and other unnecessary data to reduce
image size.

**Usage in builds:**

- Cleans package caches and temporary files
- Removes build artifacts
- Optimizes image size
- Final step in all baseline builds

### system_configure

Applies system-wide configuration settings and optimizations. This role handles
various system configuration tasks beyond the base setup.

**Usage in builds:**

- Configures system settings and parameters
- Applies performance optimizations
- Sets up system services and daemons
- Used in all baseline builds

### system_users

Manages user accounts and authentication settings. This role creates and
configures user accounts according to security policies.

**Usage in builds:**

- Creates user accounts with appropriate permissions
- Configures user groups and authentication
- Sets up sudo access if required
- Currently commented out in baseline builds but available for use

## Role Installation

Roles are installed using the `requirements.yml` file:

```bash
ansible-galaxy install -r requirements.yml
```

## Usage in Packer Builds

These roles are referenced in the Ansible playbooks used by Packer builds:

- `rhel8-baseline.yml` - RHEL 8 baseline configuration
- `rhel9-baseline.yml` - RHEL 9 baseline configuration  
- `rhel9-rke2-baseline.yml` - RHEL 9 with RKE2 configuration
- `rhel8-satellite-baseline.yml` - RHEL 8 with Satellite configuration

Each playbook applies a specific combination of these roles to create images
tailored for different use cases while maintaining security and compliance
standards.
