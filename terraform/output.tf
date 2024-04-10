output "control-plane-ip-addresses" {
    value = ["${proxmox_vm_qemu.kubernetes_vm_control.*.default_ipv4_address}"]
}

output "worker-ip-addresses" {
    value = ["${proxmox_vm_qemu.kubernetes_vm_workers.*.default_ipv4_address}"]
}