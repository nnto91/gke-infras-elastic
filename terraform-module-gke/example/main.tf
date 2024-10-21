module "test_cluster" {
  source = "../"

  cluster_name    = "newcluster"
  location        = local.location
  network_name    = "default"
  subnet_name     = "default"
  networking_mode = "VPC_NATIVE"

  cluster_ipv4_cidr_block = "10.1.0.0/16"
  services_ipv4_cidr_block = "10.21.0.0/16"

  cluster_dns        = "CLOUD_DNS"
  cluster_dns_scope  = "VPC_SCOPE"
  cluster_dns_domain = "newcluster"
  cluster_labels    = {
    env = "production"
  }
  node_pools = [ 
    {
      name           = "highmem-pool"
      machine_type   = "n2-highmem-4"
      min_node_count = 1
      max_node_count = 3
      taint          = [
        {
          key    = "high_mem"
          value  = "true"
          effect = "NO_SCHEDULE"
        },
        {
          key    = "application"
          value  = "api"
          effect = "NO_SCHEDULE"
        }
      ]
    },
    {
      name           = "standard-pool"
      min_node_count = 1
      max_node_count = 5
      disk_size_gb   = 50
      labels = {
        app  = "golang"
        mode = "api"
      }
    }
  ]
}
