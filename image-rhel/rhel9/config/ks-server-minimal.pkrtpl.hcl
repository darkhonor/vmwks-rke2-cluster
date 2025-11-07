# Copyright 2023-2024 Broadcom. All rights reserved.
# SPDX-License-Identifier: BSD-2

# Oracle Linux Server 9

### Installs from the first attached CD-ROM/DVD on the system.
cdrom

### Performs the kickstart installation in text mode.
### By default, kickstart installations are performed in graphical mode.
text

### Accepts the End User License Agreement.
eula --agreed

### Sets the language to use during installation and the default language to use on the installed system.
lang ${vm_guest_os_language}

### Sets the default keyboard type for the system.
keyboard ${vm_guest_os_keyboard}

### Configure network information for target system and activate network devices in the installer environment (optional)
### --onboot	  enable device at a boot time
### --device	  device to be activated and / or configured with the network command
### --bootproto	  method to obtain networking configuration for device (default dhcp)
### --noipv6	  disable IPv6 on this device
${network}

### Lock the root account.
rootpw --lock

### The selected profile will restrict root login.
### Add a user that can login and escalate privileges.
user --name=${ansible_username} --lock --groups=wheel
sshkey --username=${ansible_username} "${ansible_key}"

### Configure firewall settings for the system.
### --enabled	reject incoming connections that are not in response to outbound requests
### --ssh		allow sshd service through the firewall
firewall --enabled --ssh

### Sets up the authentication options for the system.
### The SSDD profile sets sha512 to hash passwords. Passwords are shadowed by default
### See the manual page for authselect-profile for a complete list of possible options.
authselect select sssd

### Sets the state of SELinux on the installed system.
### Defaults to enforcing.
selinux --enforcing

### Sets the system time zone.
timezone ${vm_guest_os_timezone}

### Partitioning
${storage}

### Modifies the default set of services that will run under the default runlevel.
services --enabled=NetworkManager,sshd

### Do not configure X on the installed system.
skipx

### Disable kdump per STIG
%addon com_redhat_kdump --disable

%end

### Add DISA Red Hat Enterprise Linux 9 STIG SCAP Profile
### STIG Configured via Ansible
%addon com_redhat_oscap
    content-type = scap-security-guide
    datastream-id = scap_org.open-scap_datastream_from_xccdf_ssg-rhel9-xccdf.xml
    xccdf-id = scap_org.open-scap_cref_ssg-rhel9-xccdf.xml
    profile = xccdf_org.ssgproject.content_profile_stig
%end
###

### Packages selection.
%packages --ignoremissing --excludedocs
@^minimal-environment
@guest-agents
aide
audispd-plugins
audit
chrony
crypto-policies
fapolicyd
firewalld
gnutls-utils
libreswan
nss-tools
opensc
openscap
openscap-scanner
openssh-clients
openssh-server
openssl-pkcs11
pcsc-lite
policycoreutils
policycoreutils-python-utils
rng-tools
rsyslog
rsyslog-gnutls
scap-security-guide
sudo
tmux
usbguard
libicu      # Added 10 Dec 24: CND rqmt for EvaluateSTIG
lshw        # Added 10 Dec 24: CND rqmt for EvaluateSTIG
cloud-init
esc
ca-certificates
-iprutils
-nfs-utils
-quagga
-sendmail
-telnet-server
-tftp-server
-tuned
-vsftpd
-xorg-x11-server-common
-iwl*firmware
%end

### Run the Setup Agent on first boot
firstboot --enable

### Post-installation commands.
%post
### dnf install -y oracle-epel-release-el9
dnf makecache
dnf install -y sudo open-vm-tools perl
%{ if additional_packages != "" ~}
dnf install -y ${additional_packages}
%{ endif ~}
echo "${ansible_username} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${ansible_username}
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
%end

### Reboot after the installation is complete.
### --eject attempt to eject the media before rebooting.
reboot --eject
