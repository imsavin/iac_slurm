resource "proxmox_vm_qemu" "slurm_master" {
  count             = 1
  name              = "slurm-master.loc"
  target_node       = "proxmox"

  clone             = "ubuntu-2004-cloudinit-template1"

  os_type           = "cloud-init"
  cores             = 1
  sockets           = "1"
  cpu               = "host"
  memory            = 512
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
  agent = 0

  disk {
    size            = "10G"
    type            = "virtio"
    storage         = "local-lvm"
    }

  network {
    model           = "virtio"
    bridge          = "vmbr0"
  }

  lifecycle {
    ignore_changes  = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0         = "ip=192.168.1.220/24,gw=192.168.1.1"
}

resource "proxmox_vm_qemu" "slurm_node" {
  count             = 3
  name              = "slurm-node-${count.index+1}.loc"
  target_node       = "proxmox"

  clone             = "ubuntu-2004-cloudinit-template1"

  os_type           = "cloud-init"
  cores             = 1
  sockets           = "1"
  cpu               = "host"
  memory            = 512
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
  agent = 0

  disk {
    size            = "10G"
    type            = "virtio"
    storage         = "local-lvm"
    }

  network {
    model           = "virtio"
    bridge          = "vmbr0"
  }

  lifecycle {
    ignore_changes  = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0         = "ip=192.168.1.22${count.index+1}/24,gw=192.168.1.1"
}