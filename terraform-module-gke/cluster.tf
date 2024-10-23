locals {
  channel = var.release_channel != null ? [var.release_channel] : []
}
resource "google_container_cluster" "gke_cluster" {
  name                     = var.cluster_name
  location                 = var.location
  network                  = var.network_name
  subnetwork               = var.subnet_name
  remove_default_node_pool = true
  initial_node_count       = 1
  networking_mode          = var.networking_mode
  logging_service          = var.logging_service
  min_master_version = var.release_channel == "UNSPECIFIED" ? var.master_version : "latest"
  deletion_protection = false
  dynamic "release_channel" {
    for_each = local.channel
    content {
      channel = var.release_channel
    }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block 
  }
  dns_config {
    cluster_dns        = var.cluster_dns
    cluster_dns_scope  = var.cluster_dns_scope
    cluster_dns_domain = var.cluster_dns_domain
  }
  #tags                     = var.tags
  resource_labels           = var.cluster_labels
  # resource_usage_export_config {
  #   enable_network_egress_metering = var.enable_network_egress_metering
  #   enable_resource_consumption_metering = var.enable_resource_consumption_metering

  #   bigquery_destination {
  #     dataset_id = var.cluster_resource_usage
  #   }
  # }
  lifecycle {
    ignore_changes = [
      ip_allocation_policy,
      min_master_version,
      release_channel
    ]
  }
  maintenance_policy {
    recurring_window {
      start_time = var.start_time
      end_time = var.end_time
      recurrence = var.recurrence
    }
  }
}
