variable "vm_name" {
  description = "Proxmox VM name."
  type        = string
}

variable "vm_id" {
  description = "Proxmox VM ID."
  type        = number
}

variable "description" {
  description = "VM description."
  type        = string
}

variable "tags" {
  description = "Tags applied to the VM."
  type        = list(string)
  default     = ["terraform"]
}

variable "proxmox_node_name" {
  description = "Proxmox node that will host the VM."
  type        = string
}

variable "template_vm_id" {
  description = "Ubuntu cloud-init template VM ID."
  type        = number
}

variable "vm_datastore" {
  description = "Default datastore for VM disks."
  type        = string
}

variable "os_disk_datastore" {
  description = "Optional datastore override for the OS disk."
  type        = string
  default     = null
}

variable "data_disk_datastore" {
  description = "Optional datastore override for the extra data disk."
  type        = string
  default     = null
}

variable "cloud_init_datastore" {
  description = "Datastore used for the cloud-init drive."
  type        = string
}

variable "vm_bridge" {
  description = "Bridge used for the VM NIC."
  type        = string
}

variable "vm_username" {
  description = "Linux username created via cloud-init."
  type        = string
  default     = "ubuntu"
}

variable "vm_password" {
  description = "Optional Linux password created via cloud-init."
  type        = string
  default     = null
  sensitive   = true
}

variable "ssh_public_keys" {
  description = "SSH public keys injected by cloud-init."
  type        = list(string)
}

variable "dns_servers" {
  description = "DNS servers assigned by cloud-init."
  type        = list(string)
}

variable "search_domain" {
  description = "DNS search domain assigned by cloud-init."
  type        = string
}

variable "ipv4_address" {
  description = "Static IPv4 address in CIDR notation."
  type        = string
}

variable "ipv4_gateway" {
  description = "Default IPv4 gateway."
  type        = string
}

variable "vlan_id" {
  description = "VLAN ID for the VM NIC."
  type        = number
}

variable "cores" {
  description = "Dedicated vCPU cores."
  type        = number
}

variable "memory_mb" {
  description = "Dedicated memory in MB."
  type        = number
}

variable "os_disk_gb" {
  description = "OS disk size in GB."
  type        = number
}

variable "data_disk_gb" {
  description = "Optional extra data disk size in GB."
  type        = number
  default     = null
}

variable "firewall" {
  description = "Enable Proxmox NIC firewalling."
  type        = bool
  default     = true
}

variable "bios" {
  description = "BIOS type."
  type        = string
  default     = "seabios"
}

variable "machine" {
  description = "Optional machine type."
  type        = string
  default     = null
}

variable "started" {
  description = "Whether the VM should be started after provisioning."
  type        = bool
  default     = true
}

variable "on_boot" {
  description = "Whether the VM should start on boot."
  type        = bool
  default     = true
}

variable "stop_on_destroy" {
  description = "Stop the VM before destroy attempts."
  type        = bool
  default     = true
}

variable "enable_agent" {
  description = "Enable the Proxmox guest agent."
  type        = bool
  default     = true
}

variable "cpu_type" {
  description = "Proxmox CPU type."
  type        = string
  default     = "x86-64-v2-AES"
}

variable "hostpci_mapping" {
  description = "Optional Proxmox PCI mapping for passthrough."
  type        = string
  default     = null
}
