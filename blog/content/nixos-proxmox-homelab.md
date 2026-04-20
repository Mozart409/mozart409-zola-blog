+++
title = "Nixos Proxmox Homelab"
date = 2026-04-20
+++

## TLDR

Just show me the [code](https://github.com/Mozart409/pve-nixos-homelab)

## Preamble

How do I create / manage my vms in my homelab? I use opentofu with api access to my proxmox host. I create a new debian/fedora vm as I can supply my ssh key and activate ssh access. Then I convert this debian vm into a nixos vm via nixos-anywhere. The reason I have to do this step, as proxmox does not understand nixos and where to supply the ssh key and activate sshd. I usually deploy a minmal nixos config, basic tools curl, zsh, ss, nvim etc configure the disk via "disko" (as filesystem i mostly use btrfs but will switch to bcachefs sometime)

## Setup

Nixos desktop -> OpenTofu -> Proxmox API-> VMs

[Proxmox provider](https://github.com/bpg/terraform-provider-proxmox)

```hcl
required_providers {
  proxmox = {
    source  = "bpg/proxmox"
    version = "0.91.0" // yes i need to upgrade current latest release 0.103.0
                       // but I also need to upgrade pve to v9 before
  }
}

```

### Proxmox VE 8.4

Current VMs managed by nixos-anywhere and colmena.

- DNS (unbound dns)
- Step-ca (Certificate authority for tls certs in my homelab)
- Hermes Agent
- Postgresql (Multiple databases for projects)
- Unifi (network manager for unifi devices)
- Containers (Podman compose)
- MCP (My own mcp servers hamcp-rs, etc)
- k3s-server-1
- k3s-agent-1
- OTEL (Prometheus, Loki, Tempo, Grafana)

## Workflow

1.

```hcl
# iac/main.tf

# Debian 12 Cloud Image Download (raw format for ZFS compatibility)
resource "proxmox_virtual_environment_download_file" "debian_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "YOUR NODENAME" # e.g. pve-gigabyte

  url = "example.org"

  file_name          = "debian-12-generic-amd64.img"
  overwrite          = false
  checksum           = "ABC" # always verify the hash
  checksum_algorithm = "sha512"
}


# PostgreSQL Database VM
resource "proxmox_virtual_environment_vm" "database_vm" {
  name        = "database"
  description = "Database - Debian base for NixOS installation via nixos-anywhere"
  tags        = ["terraform", "debian", "nixos-target", "database"]

  node_name = "YOUR NODENAME" # e.g. pve-gigabyte
  vm_id     = 4323

  bios = "seabios"

  keyboard_layout = "de" # e.g. en

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 4096
    floating  = 4096
  }
  disk {
    datastore_id = "zfs_pool" # depends on your pve setup
    file_id      = proxmox_virtual_environment_download_file.debian_cloud_image.id
    interface    = "scsi0"
    size         = 64
  }
  network_device {
    bridge = "vmbr0"
  }
  operating_system {
    type = "l26"
  }
  initialization {
    datastore_id = "local-lvm"
    # Either set static ip now
    ip_config {
      ipv4 {
        address = "192.168.2.160/24"
        gateway = "192.168.2.1"
      }
    }
    # or let dhcp decide
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      username = "amadeus"
      keys     = ["ssh-ed25519 ABC user@nixos"] // Very important
    }
  }
  serial_device {}
  # Enable QEMU Guest Agent
  agent {
    enabled = true
    timeout = "60s"
  }
  started = true
  on_boot = true
}

```

2. After the vm is deployed, run [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) to install nixos via ssh, configure disks via [disko](https://github.com/nix-community/disko). This is my [basic config](https://github.com/Mozart409/pve-nixos-homelab/blob/main/modules/disko-config.nix). I usually choose a minimal config that I know succeedes, otherwise you have to delete the vm and deploy debian/fedora again, as your ssh key gets wiped during nixos installation. If the installation is successful your config must provide a ssh key to login and manage the vm.

Nix config for [minimal host](https://github.com/Mozart409/pve-nixos-homelab/blob/main/hosts/minimal/configuration.nix)
Deployment command to install nixos via ssh
`nixos-anywhere --flake .#minimal username@{{ip}}`

3. Once i created a new minimal host I manage the lifecycle via [colmena](https://github.com/zhaofengli/colmena). Part of my colmenaHive

```nix
# Host definitions
database = {
  deployment = {
    targetHost = targetHost "database"; #e.g. 192.168.1.123 / 10.11.12.13 / db.homelab.local
    targetUser = "username"; # ssh user with ssh key
    buildOnTarget = false; # Most of the time you want to build on your more powerful desktop
    tags = ["database"];
  };
  imports = [
    disko.nixosModules.disko
    agenix.nixosModules.default
    ./hosts/database/configuration.nix
  ];
};

```

4. I usually reboot my vms as they have still the "old" hostname "minimal" from the nixos-anywhere deployment, after that reboot the new hostname will be used.

`colmena exec --on {{host}} -- sudo reboot`

Just show me the [code](https://github.com/Mozart409/pve-nixos-homelab)
