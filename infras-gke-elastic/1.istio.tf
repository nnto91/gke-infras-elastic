resource "kubernetes_namespace" "istio" {
  metadata {
    name = "istio-system"
  }
  depends_on = [ module.cluster ]
}

resource "null_resource" "istio" {
  provisioner "local-exec" {
    command = "./charts/istio-1.17.0/bin/istioctl install -f ./manifests/istioOperator.yaml --set meshConfig.enableTracing=true -y"
    environment = {
      KUBECONFIG = "${path.module}/kubeconfig"
    }
  }
  depends_on = [ module.cluster, kubernetes_namespace.istio ]
}

resource "kubernetes_secret" "certificate" {
  metadata {
    name      = "treehouse-tls"
    namespace = kubernetes_namespace.istio.metadata.0.name
  }
  data = {
    "tls.crt" = var.tls_crt
    "tls.key" = var.tls_key
  }
  type = "Opaque"

  depends_on = [ null_resource.istio ]
}

resource "kubernetes_secret" "trhx_certificate" {
  metadata {
    name      = "trhx-tls"
    namespace = kubernetes_namespace.istio.metadata.0.name
  }
  data = {
    "tls.crt" = var.trhx_tls_crt
    "tls.key" = var.trhx_tls_key
  }
  type = "Opaque"

  depends_on = [ null_resource.istio ]
}

resource "null_resource" "apply_gateway" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./manifests/gateway.yaml"
    environment = {
      KUBECONFIG = "${path.module}/kubeconfig"
    }
  }
  depends_on = [ kubernetes_secret.certificate, null_resource.istio, kubernetes_secret.trhx_certificate ]
}

resource "null_resource" "apply_policy_hosts" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./manifests/policy-hosts.yaml"
    environment = {
      KUBECONFIG = "${path.module}/kubeconfig"
    }
  }
  depends_on = [ null_resource.apply_gateway ]
}