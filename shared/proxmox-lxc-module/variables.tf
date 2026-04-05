variable "hostname" {
  description = "Container hostname."
  type        = string
}

variable "vm_id" {
  description = "Proxmox container ID."
  type        = number
}

variable "description" {
  description = "Container description."
  type        = string
}

variable "tags" {
  description = "Tags applied to the container."
  type        = list(string)
  default     = ["terraform"]
}

variable "proxmox_node_name" {
  description = "Proxmox node hosting the container."
  type        = string
}

variable "vm_bridge" {
  description = "Bridge used for the container NIC."
  type        = string
}

variable "dns_servers" {
  description = "DNS servers assigned to the container."
  type        = list(string)
}

variable "search_domain" {
  description = "DNS search domain assigned to the container."
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
  description = "VLAN ID for the container NIC."
  type        = number
}

variable "cores" {
  description = "Dedicated CPU cores."
  type        = number
}

variable "memory_mb" {
  description = "Dedicated memory in MB."
  type        = number
}

variable "swap_mb" {
  description = "Swap in MB."
  type        = number
}

variable "disk_gb" {
  description = "Disk size in GB."
  type        = number
}

variable "datastore_id" {
  description = "Datastore for the container disk."
  type        = string
}

variable "start_on_boot" {
  description = "Whether the container should start on boot."
  type        = bool
  default     = true
}

variable "unprivileged" {
  description = "Whether the container is unprivileged."
  type        = bool
  default     = true
}

variable "firewall" {
  description = "Enable Proxmox firewall on the container NIC."
  type        = bool
  default     = true
}
