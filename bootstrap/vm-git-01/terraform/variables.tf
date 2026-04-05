// Supply these inputs with TF_VAR_* environment variables. No terraform.tfvars
// files are tracked in this repo.
variable "proxmox_api_url" {
  description = "Proxmox API URL, for example https://pve-01.example.com:8006/api2/json."
  type        = string
}

variable "proxmox_api_token" {
  description = "API token in the form user@realm!token-name=token-secret."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Allow invalid TLS certificates for the Proxmox API."
  type        = bool
  default     = false
}

variable "proxmox_node_name" {
  description = "Proxmox node that will host git-01."
  type        = string
}

variable "template_vm_id" {
  description = "Ubuntu cloud-init template VM ID."
  type        = number
}

variable "vm_datastore" {
  description = "Primary datastore for the OS disk."
  type        = string
}

variable "gitlab_data_datastore" {
  description = "Datastore for the GitLab data disk."
  type        = string
}

variable "cloud_init_datastore" {
  description = "Datastore used for the cloud-init drive."
  type        = string
}

variable "vm_bridge" {
  description = "Bridge used for the GitLab VM NIC."
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

variable "gitlab_vm_name" {
  description = "VM name for the GitLab host."
  type        = string
  default     = "git-01"
}

variable "gitlab_vm_id" {
  description = "VM ID for the GitLab host."
  type        = number
  default     = 4001
}

variable "gitlab_vlan_id" {
  description = "VLAN ID for the GitLab host."
  type        = number
  default     = 40
}

variable "gitlab_ipv4_address" {
  description = "Static IPv4 address in CIDR notation."
  type        = string
  default     = "192.168.40.10/24"
}

variable "gitlab_ipv4_gateway" {
  description = "Default gateway for the GitLab host."
  type        = string
  default     = "192.168.40.1"
}

variable "gitlab_cores" {
  description = "vCPU cores for the GitLab host."
  type        = number
  default     = 4
}

variable "gitlab_memory_mb" {
  description = "Dedicated memory in MB for the GitLab host."
  type        = number
  default     = 8192
}

variable "gitlab_os_disk_gb" {
  description = "OS disk size in GB."
  type        = number
  default     = 50
}

variable "gitlab_data_disk_gb" {
  description = "Persistent data disk size in GB."
  type        = number
  default     = 100
}
