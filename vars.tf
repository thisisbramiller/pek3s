variable "proxmox_host" {
  default = "pve"
}

variable "template_name" {
  default = "ubuntu-cloud"
}

variable "username" {
  default = "serveradmin"
}

variable "ssh_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN22ORUO3S2egwyYBS2k/hJ22aS/f4rHSNEoRPnES+NF"
}

variable "k8s_control_instances" {
  default = 1
}

variable "k8s_control_memory" {
  default = 4096
}

variable "k8s_worker_instances" {
  default = 2
}

variable "k8s_worker_memory" {
  default = 4096
}
