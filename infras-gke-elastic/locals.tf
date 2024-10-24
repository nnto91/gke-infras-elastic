locals {
  location                 = "asia-southeast1-b"
  project_id               = "sharp-respect-347505"
  gcp_location_parts       = split("-", local.location)
  gcp_region               = format("%s-%s", local.gcp_location_parts[0], local.gcp_location_parts[1])
  cluster_name             = "production-tools"
  env                      = "production"
  bucket                   = "tf-gke-elastic"
  prefix_bucket            = "infras-gke/${local.cluster_name}/state"
  credentials              = "./environment/svc-acc.json"
  master_version           = "1.30.5-gke.1014001"
  release_channel          = "UNSPECIFIED"
  cluster_ipv4_cidr_block  = "10.110.0.0/16"
  services_ipv4_cidr_block = "10.100.0.0/16"
  network_name             = "prod"
  subnet_name              = "prod"
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = local.cluster_name
    clusters        = [{
      cluster = {
        certificate-authority-data = module.cluster.cluster_ca_certificate
        server                     = "https://${module.cluster.gke_host_name}"
      }
      name =  local.cluster_name
    }]
    contexts = [{
      context = {
        cluster = local.cluster_name
        user    = local.cluster_name
      }
      name = local.cluster_name
    }]
    users = [{
      name = local.cluster_name
      user = {
        token = "${data.google_client_config.provider.access_token}"
      }
    }]
  })
}

resource "local_file" "kubeconfig" {
  content  = local.kubeconfig
  filename = "${path.module}/kubeconfig"
}