output "gke_cluster_id" {
  value = google_container_cluster.gke_cluster.id
}

output "gke_cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "gke_host_name" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "node_pool_ids" {
  value = google_container_node_pool.my_pools.*.id
}

output "node_pool_name" {
  value = google_container_node_pool.my_pools.*.name
}

output "cluster_ca_certificate" {
  value = google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate
}