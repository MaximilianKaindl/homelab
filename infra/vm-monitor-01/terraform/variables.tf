// Supply these inputs with TF_VAR_* environment variables. No terraform.tfvars
// files are tracked in this repo.
variable "proxmox_api_url" {
  description = "Proxmox API URL, for example https://proxmox.example.internal:8006/api2/json."
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
  description = "Proxmox node that will host the VM."
  type        = string
}

variable "template_vm_id" {
  description = "Ubuntu cloud-init template VM ID."
  type        = number
}

variable "vm_datastore" {
  description = "Default datastore for the OS disk."
  type        = string
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

variable "search_domain" {
  description = "DNS search domain assigned by cloud-init."
  type        = string
}
