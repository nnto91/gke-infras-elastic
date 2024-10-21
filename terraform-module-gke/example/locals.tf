locals {
  location           = "asia-southeast1-b"
  project_id         = 651721216920
  gcp_location_parts = split("-", local.location)
  gcp_region         = format("%s-%s", local.gcp_location_parts[0], local.gcp_location_parts[1])
}