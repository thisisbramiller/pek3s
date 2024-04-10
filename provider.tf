terraform {
  cloud {
    organization = "bramiller"

    workspaces {
      name = "pek3s"
    }
  }
  
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://192.168.40.49:8006/api2/json"
  pm_tls_insecure = true
}