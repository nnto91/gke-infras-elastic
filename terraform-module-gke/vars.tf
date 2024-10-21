variable "cluster_name" {
  description = "GKE Cluster Name"
}

variable "location" {
  default     = "asia-southeast1-b"
  description = "GKE Cluster Name"
}

variable "network_name" {
  description = "VPC ID"
}

variable "subnet_name" {
  description = "Subnet ID"
}

variable "cluster_dns" {
  default     = "PROVIDER_UNSPECIFIED" ### PROVIDER_UNSPECIFIED (default) or PLATFORM_DEFAULT or CLOUD_DNS
  description = "Define type of cluster DNS" 
}

variable "cluster_dns_scope" {
  default     = "DNS_SCOPE_UNSPECIFIED" ### DNS_SCOPE_UNSPECIFIED (default) or CLUSTER_SCOPE or VPC_SCOPE
  description = "Define scope of cluster DNS"
}

variable "private_nodes" {
  default     = false
  description = "Enable private nodes"
}
variable "cluster_dns_domain" {
  default     = ""
  description = "The suffix used for all cluster service records"
}

variable "node_pools" {
  description = "Define list of Node Pools"
}

variable "networking_mode" {
  default     = "ROUTES"
  description = "Define network mode Route or VPC_Native"
}

variable "cluster_ipv4_cidr_block" {
  default = ""
}

variable "services_ipv4_cidr_block" {
  default = ""
}

variable "cluster_labels" {
  description = "Define cluster labels by environments"
  default = ""
}

variable "enable_network_egress_metering" {
  description = "Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic."
  default = "false"
}

variable "enable_resource_consumption_metering" {
  description = "Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export."
  default = "true"
}

variable "cluster_resource_usage" {
  description = "The ID of a BigQuery Dataset"
  default = "thfc_billing_export"
}

variable "release_channel" {
  description = "Use to set release channel: Static, Release, Stable, ...."
}

variable "master_version" {
  description = "Set k8s version"
  default = "1.26.10-gke.1101000"
}

variable "logging_service" {
  default = "none"
  description = "The logging service that the cluster should write logs to"
}

variable "start_time" {
  default = "2024-01-14T17:00:00Z"
  description = "The start time of main maintenance_policy"
}

variable "end_time" {
  default = "2024-01-15T17:00:00Z"
  description = "The end time of main maintenance_policy"
}

variable "recurrence" {
  default = "FREQ=WEEKLY;BYDAY=SA,SU"
  description = "The recurrence of main maintenance_policy"
}
