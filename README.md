# gke-infras-elastic
# High Availability, Authenticated Elasticsearch Cluster Setup on GKE

This guide provides step-by-step instructions for setting up a high-availability, authenticated Elasticsearch cluster on Google Kubernetes Engine (GKE) using Terraform. It includes instructions to:

- Provision a GKE cluster with Terraform
- Install Elasticsearch using Helm or a custom Kubernetes manifest
- Generate SSL certificates for Elasticsearch
- Create Kubernetes secrets for Elasticsearch certificates
- Test Elasticsearch using `curl`

## Prerequisites

Before you begin, ensure you have the following tools installed locally:

- [Terraform](https://www.terraform.io/downloads.html) (v0.14+)
- [gcloud SDK](https://cloud.google.com/sdk/docs/install) configured with access to your Google Cloud project
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/) (if using Helm to install Elasticsearch)
- [OpenSSL](https://www.openssl.org/) for generating certificates
- A Google Cloud project with billing enabled

1. **Create the GCS Bucket**

   Use the `gsutil` command to create a GCS bucket:
  ```bash
    gsutil mb -l <region> gs://<your-unique-bucket-name>/
  ```
Replace <region> with your desired region (e.g., asia-southeast1), and <your-unique-bucket-name> with a globally unique name for your GCS bucket.

2. **Configure Terraform Variables**

Edit the locals.tf file or export the necessary environment variables to define your GCP project ID, region, cluster name, and node settings.

  location                 = "asia-southeast1-b"
  project_id               = "sharp-respect-347505"
  gcp_location_parts       = split("-", local.location)
  gcp_region               = format("%s-%s", local.gcp_location_parts[0], local.gcp_location_parts[1])
  cluster_name             = "production-tools"
  env                      = "production"
  bucket                   = "tf-gke-elastic"
  prefix_bucket            = "infras-gke/${local.cluster_name}/state"
  master_version           = "1.30.5-gke.1014001"
  release_channel          = "UNSPECIFIED"
  cluster_ipv4_cidr_block  = "10.110.0.0/16"
  services_ipv4_cidr_block = "10.100.0.0/16"
  network_name             = "prod"
  subnet_name              = "prod"

3. **Apply Terraform Configuration**
After configuring the local files, reinitialize Terraform to make sure the backend is set up correctly:
  ```bash
  terraform init
  teraform plan
  terraform apply
  ```
The whole set of provisioning a GKE cluster and elasticsearch helm-charts will automate deploy with these terraform template

4. **Generate SSL Certificates and Create Kubernetes Secrets**
  ```bash
  sudo docker run --name elastic-helm-charts-certs -i -w /tmp docker.elastic.co/elasticsearch/elasticsearch:8.5.1 \
		/bin/sh -c " \
			elasticsearch-certutil ca --out /tmp/elastic-stack-ca.p12 --pass '' && \
			elasticsearch-certutil cert --name security-master --dns security-master --ca /tmp/elastic-stack-ca.p12 --pass '' --ca-pass '' --out /tmp/elastic-certificates.p12"

  sudo docker cp elastic-helm-charts-certs:/tmp/elastic-certificates.p12 ./
  sudo docker rm -f elastic-helm-charts-certs 

	openssl pkcs12 -nodes -passin pass:'' -in elastic-certificates.p12 -out elastic-certificate.pem
	openssl x509 -outform der -in elastic-certificate.pem -out elastic-certificate.crt
	kubectl create secret generic elastic-certificates --from-file=elastic-certificates.p12
  ```
**Notes: I already generated set of elastic certificates in the manifests folder, we can re-use it or generate a new one**

5. **Test the Elasticsearch Cluster**
- Get the Elasticsearch service URL using kubectl and Copy the external IP or Cluster IP.
  kubectl get svc elasticsearch-master
- Use port-forward to run service in local port
  kubectl port-forward svc/elastic-master 9200:9200 -n elasticsearch

- Add DNS to hosts file
  ```bash
    vim /etc/hosts
    127.0.0.1     security-master
    <external IP> security-master
  ```

- To test the Elasticsearch cluster, use the curl command with authentication and the SSL certificate:

ELASTIC_PASSWORD=$(kubectl get secrets --namespace=elasticsearch elastic-master-credentials -ojsonpath='{.data.password}' | base64 -d)
curl -v --cacert manifests/elastic-certificate.pem -u elastic:$ELASTIC_PASSWORD -X GET 'https://security-master:9200/_cluster/health?pretty'

