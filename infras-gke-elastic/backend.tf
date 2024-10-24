terraform {
  backend "gcs" {
    bucket = local.bucket
    prefix = local.prefix_bucket
    credentials = local.credentials
  }
}
