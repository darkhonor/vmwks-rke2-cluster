# Common Packer Configurations

This directory contains shared configuration files used across multiple
Packer builds for RHEL images.

## Directory Contents

- **`common.pkrvars.hcl`** - Common variables shared across all Packer builds
  including VM configuration, build timeouts, and shared parameters
- **`linux-storage.pkrvars.hcl`** - Linux storage configuration settings
  including disk partitioning, filesystem options, and storage controllers
- **`network.pkrvars.hcl`** - Network configuration parameters including
  IP settings, DNS configuration, and network adapter specifications
