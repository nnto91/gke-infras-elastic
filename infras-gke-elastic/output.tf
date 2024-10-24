output "gke_cluster_id" {
  value = module.cluster.gke_cluster_id
}

output "gke_cluster_name" {
  value = module.cluster.gke_cluster_name
}

output "gke_host_name" {
  value = module.cluster.gke_host_name
}

output "node_pool_ids" {
  value = module.cluster.node_pool_ids
}

output "node_pool_name" {
  value = module.cluster.node_pool_name
}
output "cluster_ca_certificate" {
  value = module.cluster.cluster_ca_certificate
}