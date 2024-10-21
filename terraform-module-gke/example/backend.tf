terraform {
	backend "gcs" {
		bucket  = "terraform-services-bucket"
		prefix  = "gke/state"
	}
}
