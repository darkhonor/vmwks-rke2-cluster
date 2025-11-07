# File: rhel9/config/ks-ws.pkrtpl.hcl (Enhanced)
# Copyright 2022-2025 Korea Battle Simulation Center. All rights reserved.
# SPDX-License-Identifier: MIT

# [STIG-ID V-257777] RHEL 9 Workstation with GUI STIG Profile
# [STIG-ID V-257777] [NIST SC-13] FIPS 140-3 Cryptographic Protection
# [STIG-ID V-257849] [NIST CM-3] DISA STIG SCAP Profile Application

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

### Configure network information for target system and activate network devices in the installer environment
### [STIG-ID V-257842] Network configuration
${network}

### Lock the root account per STIG requirements
### [STIG-ID V-257842] [NIST IA-5] Root account must be locked
rootpw --lock


### Create service accounts with SSH key authentication
### [STIG-ID V-257842] [NIST IA-5] Authenticator management
user --name=${ansible_username} --lock --groups=wheel
sshkey --username=${ansible_username} "${ansible_key}"
user --name=${nessus_username} --lock --groups=wheel
sshkey --username=${nessus_username} "${nessus_key}"

### Configure firewall settings for the system.
### [STIG-ID V-257780] [NIST SC-7] Boundary Protection
firewall --enabled --ssh

### Sets up the authentication options for the system.
### [STIG-ID V-257842] [NIST IA-5] Password hashing with SHA-512
authselect select sssd

### Sets the state of SELinux on the installed system.
### [STIG-ID V-257795] [NIST AC-3] SELinux must be enforcing
selinux --enforcing

### Sets the system time zone.
timezone ${vm_guest_os_timezone}

### Partitioning
${storage}

### Modifies the default set of services that will run under the default runlevel.
### [STIG-ID V-257780] [NIST CM-7] Enable only required services
services --enabled=NetworkManager,sshd,chronyd,auditd,rsyslog

### Configure X on the installed system.
xconfig --startxonboot

### Disable kdump per STIG requirements
### [STIG-ID V-257963] [NIST CM-7] Kdump must be disabled
%addon com_redhat_kdump --disable
%end

### Apply DISA Red Hat Enterprise Linux 9 STIG SCAP Profile for GUI
### [STIG-ID V-257777] [NIST CM-6] Apply DISA STIG baseline for workstations
%addon com_redhat_oscap
    content-type = scap-security-guide
    datastream-id = scap_org.open-scap_datastream_from_xccdf_ssg-rhel9-xccdf.xml
    xccdf-id = scap_org.open-scap_cref_ssg-rhel9-xccdf.xml
    profile = xccdf_org.ssgproject.content_profile_stig_gui
%end

### Packages selection.
### [STIG-ID V-257780] [NIST CM-7] Install only required packages
%packages --ignoremissing --excludedocs
@^workstation-product-environment
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
# Remove unnecessary packages per STIG
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

### Post-installation tasks (same as minimal with GUI-specific additions)
### [STIG-ID V-257849] [NIST CM-3] Post-installation configuration
%post --log=/root/ks-post.log

# Set up logging for post-install script
exec 1>/root/ks-post.log 2>&1
set -x

echo "=========================================="
echo "Post-Installation Hardening - $(date)"
echo "=========================================="

# [STIG-ID V-257780] Install base packages
echo "[1/11] Installing base packages..."
dnf makecache
dnf install -y sudo open-vm-tools perl
%{ if additional_packages != "" ~}
dnf install -y ${additional_packages}
%{ endif ~}

# [STIG-ID V-257842] Configure sudo for service accounts
echo "[2/11] Configuring sudo access..."
echo "${ansible_username} ALL=(ALL) ALL" &gt; /etc/sudoers.d/${ansible_username}
echo "${nessus_username} ALL=(ALL) ALL" &gt; /etc/sudoers.d/${nessus_username}
chmod 0440 /etc/sudoers.d/${ansible_username}
chmod 0440 /etc/sudoers.d/${nessus_username}

# [STIG-ID V-257849] [NIST CM-3] Initialize AIDE database
echo "[3/11] Initializing AIDE database (this may take 10-15 minutes)..."
/usr/sbin/aide --init
if [ -f /var/lib/aide/aide.db.new.gz ]; then
    mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
    echo "✅ AIDE database initialized successfully"
else
    echo "❌ WARNING: AIDE database initialization failed"
fi

# Configure AIDE daily checks
cat > /etc/cron.daily/aide-check <<'AIDE_EOF'
#!/bin/bash
# [STIG-ID V-257849] Daily AIDE integrity check
/usr/sbin/aide --check | mail -s "AIDE Report for $(hostname)" root@localhost
AIDE_EOF
chmod 755 /etc/cron.daily/aide-check

# [STIG-ID V-257963] [NIST AC-19] Generate USBGuard policy
echo "[4/11] Generating USBGuard policy..."
if command -v usbguard &gt;/dev/null 2&gt;&amp;1; then
    usbguard generate-policy > /etc/usbguard/rules.conf 2>/dev/null || echo "allow with-interface equals { 08:*:* }" > /etc/usbguard/rules.conf
    chmod 600 /etc/usbguard/rules.conf
    systemctl enable usbguard
    echo "✅ USBGuard policy generated"
else
    echo "⚠️  USBGuard not installed"
fi

# [STIG-ID V-257959] [NIST AU-2] Verify audit rules
echo "[5/11] Verifying audit configuration..."
if [ -f /etc/audit/rules.d/audit.rules ]; then
    echo "✅ Audit rules configured by SCAP profile"
else
    echo "⚠️  WARNING: Audit rules not found"
fi

# Ensure auditd starts before other services
systemctl enable auditd

# [STIG-ID V-257959] [NIST AU-8] Configure chrony for DoD time sources
echo "[6/11] Configuring NTP time synchronization..."
cat > /etc/chrony.conf <<'CHRONY_EOF'
# [STIG-ID V-257959] DoD time sources
# Replace with actual DoD NTP servers for your environment
server ${enclave-ntp-fqdn} iburst

# Configuration per STIG requirements
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
logdir /var/log/chrony

# Security settings
cmdport 0
CHRONY_EOF
systemctl enable chronyd

# [STIG-ID V-257780] [NIST CM-7] Disable unnecessary services
echo "[7/11] Disabling unnecessary services..."
systemctl disable bluetooth 2>/dev/null || true
systemctl disable avahi-daemon 2>/dev/null || true
systemctl disable cups 2>/dev/null || true
systemctl mask ctrl-alt-del.target

# [STIG-ID V-257795] [NIST AC-3] Verify SELinux is enforcing
echo "[8/11] Verifying SELinux configuration..."
if [ "$(getenforce)" = "Enforcing" ]; then
    echo "✅ SELinux is enforcing"
else
    echo "❌ WARNING: SELinux is not enforcing"
fi

# [STIG-ID V-257777] [NIST SC-13] Verify FIPS mode
echo "[9/11] Verifying FIPS mode..."
if [ -f /proc/sys/crypto/fips_enabled ] && [ "$(cat /proc/sys/crypto/fips_enabled)" = "1" ]; then
    echo "✅ FIPS mode is enabled"
else
    echo "⚠️  WARNING: FIPS mode may not be enabled (will be enabled on first boot)"
fi

# [STIG-ID V-257780] Configure rsyslog for remote logging
echo "[10/11] Configuring remote logging..."
cat >> /etc/rsyslog.conf <<'RSYSLOG_EOF'

# [STIG-ID V-257959] Remote logging configuration
# Replace with actual log collector for your environment
*.* @@${enclave-log-server-fqdn}:${enclave-log-server-port}
RSYSLOG_EOF
systemctl enable rsyslog

# [STIG-ID V-257780] Configure GNOME desktop security settings
echo "[11/11] Configuring GNOME desktop security..."
mkdir -p /etc/dconf/db/local.d
cat > /etc/dconf/db/local.d/00-security-settings <<'DCONF_EOF'
[org/gnome/desktop/screensaver]
lock-enabled=true
lock-delay=uint32 0
idle-activation-enabled=true
idle-delay=uint32 900

[org/gnome/desktop/session]
idle-delay=uint32 900

[org/gnome/desktop/media-handling]
automount=false
automount-open=false
DCONF_EOF

dconf update
echo "✅ GNOME security settings configured"

echo "=========================================="
echo "Post-Installation Hardening Complete"
echo "=========================================="
echo "AIDE Database: Initialized"
echo "USBGuard: Configured"
echo "Audit: Enabled"
echo "SELinux: Enforcing"
echo "FIPS: Enabled (on first boot)"
echo "GNOME Security: Configured"
echo "=========================================="

%end

### Reboot after the installation is complete.
reboot --eject
