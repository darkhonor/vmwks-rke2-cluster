# VMware Workstation RKE2 Cluster - System Prompt Configuration

## Project Overview

This is a VMware Workstation RKE2 Cluster pipeline project that builds
RHEL 9.6 images using Packer and deploys them via Vagrant. The workflow
follows: RHEL 9.6 ISO → Packer:vmware:vmware-iso Builder →
Packer:vagrant Post-Processor → Vagrant Box on VMware Workstation Pro.

## Core Technologies & Standards

- **Packer**: HashiCorp Packer for image building (v1.1.0+ vsphere plugin)
- **Ansible**: Configuration management and provisioning (2.15+)
- **RHEL**: Red Hat Enterprise Linux 9.6 with FIPS compliance enabled
- **RKE2**: Rancher Kubernetes Engine 2 for Kubernetes cluster deployment
- **Vault**: HashiCorp Vault for secrets management
- **Vagrant**: Development environment management
- **VMware**: VMware Workstation Pro as the virtualization platform

## Development Guidelines

### Code Quality & Standards

1. **Production-Grade Solutions**: All implementations must be
   production-ready, secure, and follow official documentation
2. **No Creative Commands**: Only use officially supported commands
   and configurations
3. **Security First**: Never expose secrets, always use Vault for
   sensitive data
4. **FIPS Compliance**: Ensure all builds maintain FIPS 140-2 compliance
   (fips=1 in boot parameters)
5. **STIG Compliance**: Follow Security Technical Implementation Guide
   for RHEL systems
6. **Markdown Standards**: All documentation must pass markdownlint
    validation for GitHub/GitLab CE publication. Maximum line length
    is 120 characters to accommodate hyperlinks without breaking URLs.
7. **HCL Formatting Standards**: All Packer HCL templates must comply
    with HashiCorp HCL formatting standards using `packer fmt` command.

### File Structure Conventions

- Packer templates use `.pkr.hcl` extension
- Variables stored in `.pkrvars.hcl` files
- Ansible playbooks use `.yml` extension
- Configuration files in appropriate `config/` directories
- Roles follow Ansible best practices in `roles/` directory

### Build Process Requirements

1. **Validation**: Always run `./validate.sh` before building
2. **Formatting**: Use `./format.sh` to ensure consistent code style
3. **HCL Formatting**: Use `packer fmt` to format all HCL files according
   to HashiCorp standards before commits
4. **Markdown Formatting**: Use `./format-markdown.sh` to ensure proper
    documentation formatting
5. **Initialization**: Run `./initialize.sh` to set up the environment
6. **Building**: Use `./build.sh` for image construction

### Vault Integration

- All secrets must be retrieved from Vault KV store
- Use `vault-variables.pkr.hcl` for Vault-specific configurations
- Never hardcode credentials in any files
- Export VAULT_ADDR, VAULT_TOKEN, and VAULT_SKIP_VERIFY in environment

### Ansible Guidelines

- Use `ansible.cfg` for configuration
- Separate playbooks for different purposes (baseline vs
  rke2-baseline)
- Follow Ansible best practices for role structure
- Use extra variables for dynamic configuration

### Testing & Validation

- Validate Packer templates before building
- Test Ansible playbooks in dry-run mode when possible
- Verify VM templates in vSphere before use
- Ensure all builds pass security scans
- All HCL files must pass `packer fmt -check` before commits
- GitHub Actions workflows automatically validate formatting on push/PR

### Documentation Requirements

- Update README.md files with meaningful changes
- Document any new variables or configurations
- Maintain CHANGELOG for significant updates
- Include troubleshooting steps for common issues
- Run `./format.sh` before committing any changes (includes HCL, Markdown, YAML)
- Ensure all Markdown files pass markdownlint validation for
  GitHub/GitLab CE publication. Maximum line length is 120 characters
  to accommodate hyperlinks without breaking URLs.
- Ensure all HCL files are formatted with `packer fmt` before commits

## Environment Setup

Ensure these dependencies are installed and configured:

- Vault server with baseline secrets
- Ansible 2.15+
- Packer with vsphere plugin
- Vault CLI
- Vagrant
- kubectl
- Internet connectivity (unless airgapped configuration is implemented)

## Security Considerations

- Never commit secrets to version control
- Use Vault for all sensitive data
- Maintain FIPS compliance throughout the build process
- Follow least privilege principle for all access
- Regularly update dependencies and security patches

## Common Commands Reference

- `packer validate .` - Validate Packer template
- `packer build .` - Build Packer image
- `packer fmt .` - Format all HCL files according to HashiCorp standards
- `packer fmt -check .` - Check if HCL files are properly formatted
- `ansible-playbook --check` - Dry run Ansible playbook
- `vault kv get` - Retrieve secrets from Vault
- `vagrant up` - Start Vagrant environment
- `./format.sh` - Format all configuration files including HCL
- `./format-markdown.sh` - Format and lint Markdown files for
  publication
- `markdownlint '**/*.md' --config .markdownlint.json` - Manual
  Markdown linting (120 character limit for hyperlinks)

This configuration ensures consistent, secure, and production-grade
development sessions for the VMware Workstation RKE2 Cluster project.
