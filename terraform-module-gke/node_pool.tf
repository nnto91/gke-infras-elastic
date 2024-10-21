resource "google_container_node_pool" "my_pools" {
  location   = var.location
  cluster    = google_container_cluster.gke_cluster.id
  count      = length(var.node_pools)
  name       = var.node_pools[count.index].name
  
  node_count = 1

  autoscaling {
    min_node_count = lookup(var.node_pools[count.index], "min_node_count", 1)
    max_node_count = lookup(var.node_pools[count.index], "max_node_count", 5)
  }

  node_config {
    preemptible  = lookup(var.node_pools[count.index], "node_preemptible", false)
    machine_type = lookup(var.node_pools[count.index], "machine_type", "n2-standard-1")
    image_type   = lookup(var.node_pools[count.index], "image_type", "COS_CONTAINERD")
    disk_size_gb = lookup(var.node_pools[count.index], "disk_size_gb", 100)
    disk_type    = lookup(var.node_pools[count.index], "disk_type", "pd-standard")
#
#    taint  = lookup(var.node_pools[count.index], "taint", [])
    labels = lookup(var.node_pools[count.index], "labels", {})

    metadata = {
      # https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata
      disable-legacy-endpoints = "true"
    }
  }
  management {
    auto_upgrade = lookup(var.node_pools[count.index], "auto_upgrade", false)
    auto_repair = lookup(var.node_pools[count.index], "auto_repair", true)
  }
  network_config {
    create_pod_range = false
    enable_private_nodes = var.private_nodes
    pod_range = ""
  }
  lifecycle {
    ignore_changes = [
      node_config[0].taint,
      node_count
    ]

  }
}