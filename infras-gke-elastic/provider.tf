provider "google" {
  project = local.project_id
  region  = local.gcp_region

}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.31.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.2"
    }
  }
  required_version = ">= 0.13"
}

data "google_client_config" "provider" {}


provider "helm" {
  kubernetes {
    host  = "https://${module.cluster.gke_host_name}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      module.cluster.cluster_ca_certificate
    )
  }
}

provider "kubernetes" {
  host  = "https://${module.cluster.gke_host_name}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    module.cluster.cluster_ca_certificate
  )
}