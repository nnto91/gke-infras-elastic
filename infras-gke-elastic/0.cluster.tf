
module "cluster" {
  source = "../terraform-module-gke"
  cluster_name = local.cluster_name
  location     = local.location
  network_name = local.network_name
  subnet_name  = local.subnet_name
  networking_mode    = "VPC_NATIVE"
  release_channel    = local.release_channel
  master_version     = local.master_version
  private_nodes = true
  cluster_labels  = {
    env = local.env
  }
  cluster_ipv4_cidr_block              = local.cluster_ipv4_cidr_block
  services_ipv4_cidr_block             = local.services_ipv4_cidr_block
  node_pools = [
    {
      name           = "standard-pool"
      min_node_count = 1
      max_node_count = 20
      disk_size_gb   = 20
      machine_type   = "e2-standard-2"
      labels = {
        env = local.env
      }
    }
  ]
}
