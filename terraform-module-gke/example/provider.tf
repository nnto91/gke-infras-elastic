provider "google" {
  project = local.project_id
  region  = local.gcp_region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.47"
    }
  }
  required_version = ">= 0.13"
}