# File: common/linux-storage.pkrvars.hcl
# Copyright 2022-2025 Korea Battle Simulation Center. All rights reserved.
# SPDX-License-Identifier: MIT

/*
    DESCRIPTION:
    Storage variables used for Linux builds.
    - Variables are passed to and used by guest operating system configuration files (e.g., ks.cfg).
*/

// VM Storage Settings
vm_disk_device   = "sda"
vm_disk_use_swap = true

vm_disk_partitions = [
  {
    name = "efi"
    size = 1024,
    format = {
      label  = "EFIFS",
      fstype = "fat32",
    },
    mount = {
      path    = "/boot/efi",
      options = "",
    },
    volume_group = "",
  },
  {
    name = "boot"
    size = 1024,
    format = {
      label  = "BOOTFS",
      fstype = "xfs",
    },
    mount = {
      path    = "/boot",
      options = "",
    },
    volume_group = "",
  },
  {
    name = "sysvg"
    size = -1,
    format = {
      label  = "",
      fstype = "",
    },
    mount = {
      path    = "",
      options = "",
    },
    volume_group = "sysvg",
  },
]
vm_disk_lvm = [
  {
    name : "sysvg",
    partitions : [
      {
        name = "lv_swap",
        size = 8192,
        format = {
          label  = "SWAPFS",
          fstype = "swap",
        },
        mount = {
          path    = "",
          options = "",
        },
      },
      {
        name = "lv_root",
        size = -1,
        format = {
          label  = "ROOTFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/",
          options = "",
        },
      },
      {
        name = "lv_home",
        size = 10240,
        format = {
          label  = "HOMEFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/home",
          options = "nodev,nosuid",
        },
      },
      {
        name = "lv_tmp",
        size = 4096,
        format = {
          label  = "TMPFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/tmp",
          options = "nodev,noexec,nosuid",
        },
      },
      {
        name = "lv_var",
        size = 10240,
        format = {
          label  = "VARFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/var",
          options = "nodev",
        },
      },
      {
        name = "lv_vtmp",
        size = 4096,
        format = {
          label  = "VARTMPFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/var/tmp",
          options = "nodev,noexec,nosuid",
        },
      },
      {
        name = "lv_log",
        size = 5120,
        format = {
          label  = "LOGFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/var/log",
          options = "nodev,noexec,nosuid",
        },
      },
      {
        name = "lv_audit",
        size = 5120,
        format = {
          label  = "AUDITFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/var/log/audit",
          options = "nodev,noexec,nosuid",
        },
      },
    ],
  }
]

vm_disk_lvm_ws = [
  {
    name : "sysvg",
    partitions : [
      {
        name = "lv_root",
        size = 20480,
        format = {
          label  = "ROOTFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/",
          options = "",
        },
      },
      {
        name = "lv_home",
        size = -1,
        format = {
          label  = "HOMEFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/home",
          options = "nodev,nosuid",
        },
      },
      {
        name = "lv_tmp",
        size = 4096,
        format = {
          label  = "TMPFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/tmp",
          options = "nodev,noexec,nosuid",
        },
      },
      {
        name = "lv_var",
        size = 20480,
        format = {
          label  = "VARFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/var",
          options = "nodev",
        },
      },

      {
        name = "lv_vtmp",
        size = 4096,
        format = {
          label  = "VARTMPFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/var/tmp",
          options = "nodev,noexec,nosuid",
        },
      },
      {
        name = "lv_log",
        size = 5120,
        format = {
          label  = "LOGFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/var/log",
          options = "nodev,noexec,nosuid",
        },
      },
      {
        name = "lv_audit",
        size = 5120,
        format = {
          label  = "AUDITFS",
          fstype = "xfs",
        },
        mount = {
          path    = "/var/log/audit",
          options = "nodev,noexec,nosuid",
        },
      },
    ],
  }
]
