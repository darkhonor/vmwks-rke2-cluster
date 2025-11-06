# Packer Build of Red Hat Enterprise Linux 8

## Intros

This is my first test at creating an automated image of Red Hat Enterprise Linux 8 using Packer.
There are a lot of things that would need to be changed for a production environment, but
this project has helped me learn the basics of using Packer for automated Linux builds.

:cockroach: **Issues**:

- Too many static values preventing generalization of the script
- Authentication Stuff / Authentication Stuff / and Authentication Stuff --- NEED TO MIGRATE OUT

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
