
module "cluster" {
  source = "../terraform-module-gke"
  cluster_name = local.cluster_name
  location     = local.location
  network_name = local.network_name
  subnet_name  = local.subnet_name
  #cluster_dns  = "CLOUD_DNS"
  #cluster_dns_scope = "VPC_SCOPE"
  #cluster_dns_domain = local.cluster_name
  networking_mode    = "VPC_NATIVE"
  release_channel    = local.release_channel
  master_version     = local.master_version
  private_nodes = true
  cluster_labels  = {
    env = local.env
  }
  # enable_network_egress_metering       = "true"
  # enable_resource_consumption_metering = "true"
  # cluster_resource_usage               = "prd_billing_export"
  cluster_ipv4_cidr_block              = local.cluster_ipv4_cidr_block
  services_ipv4_cidr_block             = local.services_ipv4_cidr_block
  node_pools = [
    {
      name           = "standard-pool"
      min_node_count = 1
      max_node_count = 20
      disk_size_gb   = 50
      machine_type   = "n2-standard-2"
      labels = {
        env = local.env
      }
    }
  ]
}
