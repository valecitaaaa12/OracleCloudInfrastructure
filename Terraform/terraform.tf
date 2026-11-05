# terraform.tf
terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">= 5.0.0"
    }
  }
}


terraform {
  # Remoto: el estado vive en Object Storage (bucket "terraform-state-bucket").
  # La URL con Pre-Authenticated Request NO se commitea: se inyecta en init
  # desde el secreto de GitHub OCI_STATE_URL (-backend-config="address=...").
  backend "http" {
    update_method = "PUT"
  }
}