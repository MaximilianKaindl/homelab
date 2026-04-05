terraform {
  required_version = "~> 1.6"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
  }

  # Remote Terraform state can be supplied through TF_HTTP_* vars.
  # For local use run:
  #   export TF_HTTP_ADDRESS="https://git.example.internal/api/v4/projects/<ID>/terraform/state/build-01"
  #   export TF_HTTP_LOCK_ADDRESS="$TF_HTTP_ADDRESS/lock"
  #   export TF_HTTP_UNLOCK_ADDRESS="$TF_HTTP_ADDRESS/lock"
  #   export TF_HTTP_USERNAME="gitlab-ci-token"
  #   export TF_HTTP_PASSWORD="<your-personal-access-token>"
  backend "http" {}
}
