resource "proxmox_vm_qemu" "kubernetes_vm_control" {
  target_node = var.proxmox_host

  count = var.k8s_control_instances

  name = "k3s-control-${count.index}"
  vmid = "30${count.index}"

  clone = var.template_name

  agent = 1

  cores   = 2
  sockets = 1
  cpu     = "x86-64-v2-AES"
  memory  = var.k8s_control_memory
  bios    = "ovmf"
  machine = "q35"

  qemu_os = "l26"
  os_type = "cloud-init"

  cloudinit_cdrom_storage = "EX2Ultra"
  scsihw                  = "virtio-scsi-single"
  bootdisk                = "scsi0"
  boot                    = "order=scsi0"

  disks {
    scsi {
      scsi0 {
        disk {
          size     = 10
          storage  = "EX2Ultra"
          iothread = true
        }
      }
    }
  }

  network {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  ipconfig0 = "ip=192.168.40.3${count.index}/24,gw=192.168.40.1"
  ciuser    = var.username
  sshkeys   = <<EOF
  ${var.ssh_key}
${var.ssh_key_ci}
  EOF

  lifecycle {
    ignore_changes = [
      bootdisk, id,
    ]
  }
}

resource "proxmox_vm_qemu" "kubernetes_vm_workers" {
  target_node = var.proxmox_host

  count = var.k8s_worker_instances

  name = "k3s-worker-${count.index}"
  vmid = "40${count.index}"

  clone = var.template_name

  agent = 1

  cores   = 2
  sockets = 1
  cpu     = "x86-64-v2-AES"
  memory  = var.k8s_worker_memory
  bios    = "ovmf"
  machine = "q35"

  qemu_os = "l26"
  os_type = "cloud-init"

  cloudinit_cdrom_storage = "EX2Ultra"
  scsihw                  = "virtio-scsi-single"
  bootdisk                = "scsi0"
  boot                    = "order=scsi0"

  disks {
    scsi {
      scsi0 {
        disk {
          size     = 20
          storage  = "EX2Ultra"
          iothread = true
        }
      }
    }
  }

  network {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  ipconfig0 = "ip=192.168.40.4${count.index}/24,gw=192.168.40.1"
  ciuser    = var.username
  sshkeys   = <<EOT
  ${var.ssh_key}
${var.ssh_key_ci}
  EOT

  lifecycle {
    ignore_changes = [
      network, bootdisk,
    ]
  }

}

data "template_file" "k3s" {
  template = file("./templates/k3s.tpl")
  vars = {
    control_plane_ips = "${join("\n", [for instance in proxmox_vm_qemu.kubernetes_vm_control : join("", [instance.default_ipv4_address])])}"
    worker_node_ips   = "${join("\n", [for instance in proxmox_vm_qemu.kubernetes_vm_workers : join("", [instance.default_ipv4_address])])}"
  }
}

resource "local_file" "k3s_ansible_inventory" {
  content  = data.template_file.k3s.rendered
  filename = "../ansible/inventory/inventory.ini"
}

data "template_file" "generate_known_hosts" {
  template = file("./templates/generate_known_hosts.tpl")
  vars = {
    all_ips = "${concat(proxmox_vm_qemu.kubernetes_vm_control.*.default_ipv4_address, proxmox_vm_qemu.kubernetes_vm_workers.*.default_ipv4_address)}"
  }
}

resource "local_file" "generate_known_hosts" {
  content  = data.template_file.generate_known_hosts.rendered
  filename = "./scripts/generate_known_hosts.sh"
  file_permission = "0755"
}