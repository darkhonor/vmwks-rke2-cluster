# VMware Workstation RKE2 Cluster

This is the pipeline project for testing [RKE2](https://rke2.io) Cluster deployment.

The design follows this workflow:

RHEL 9.6 ISO → Packer:vmware:vmware-iso Builder →
Packer:vagrant Post-Processor → Vagrant Box on VMware Workstation Pro

## Directory Structure

- **`.github/`** - Contains GitHub Actions workflows for automated
  CI/CD processes
- **`image-rhel/`** - Packer templates and configurations for building RHEL 9.6 images
- **`rke2-cluster/`** - Vagrant configuration for deploying RKE2 clusters
- **`AGENTS.md`** - System prompt configuration for development agents
- **`CHANGELOG`** - Project change history and version updates
- **`CODEOWNERS`** - Code ownership and review assignment rules
- **`CONTRIBUTING.md`** - Guidelines for contributing to the project
- **`LICENSE`** - Project license information
- **`MARKDOWN-STANDARDS.md`** - Markdown formatting standards for documentation
- **`.gitignore`** - Git ignore patterns for the project
- **`.markdownlint.json`** - Configuration for markdown linting rules
- **`.yamllint`** - Configuration for YAML linting rules
- **`format-markdown.sh`** - Script to format and lint Markdown files

## Dependencies

The following dependencies are **required** before you use this build:

- Vault Server with Baseline Secrets in a KV store (separate from
  local install)
- Linux system or WSL (required for Ansible)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) 2.15+ Installed
- [Packer](https://developer.hashicorp.com/packer/install) Installed
- [Vault](https://developer.hashicorp.com/vault/install) Installed (for CLI)
- [Vagrant](https://developer.hashicorp.com/vagrant/install) Installed
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) Installed
- Internet connection (you **can** airgap this, but lots of edits to
  make)

### Vault Server Configuration

In order to run this plan, we need to configure the system to know where
the Vault server is and the
[token](https://developer.hashicorp.com/vault/docs/concepts/tokens)
used for authentication. As this is for a **DEV** build and **NOT**
production, this can just be another VM or within WSL itself and
only accessible from `localhost`.

Add the following to your `~/.bashrc` file:

```bash
# Vault Configuration
export VAULT_ADDR=https://localhost:8200
export VAULT_TOKEN=$(< ~/.vault-token)
# DO NOT SET THE FOLLOWING IN PRODUCTION
export VAULT_SKIP_VERIFY=true
```

Either restart the terminal session or type the following before
running the build to ensure these changes take effect:

```bash
source ~/.bashrc
```

Consult the Knowledgebase for a more detailed setup for the
Development Vault server.

## Run the Template Build (Gold Image)

To build the RHEL 9.6 template:

```bash
cd image-rhel
./initialize.sh
./validate.sh
./build.sh
```

## Documentation Standards

This project follows strict formatting standards for all file types:

- **Markdown**: 120 character line limit, proper heading structure
- **HCL**: HashiCorp Packer formatting standards using `packer fmt`
- **YAML**: Consistent indentation and structure validation

See [MARKDOWN-STANDARDS.md](MARKDOWN-STANDARDS.md) for detailed guidelines.

To format all files before committing:

```bash
./format.sh
```

To format specific file types:

```bash
# HCL files only
packer fmt .

# Markdown files only
./format-markdown.sh
```

## Author Information

Alex Ackerman, <alexander.ackerman@sosi.com>, GitHub
[@darkhonor](https://github.com/darkhonor)
