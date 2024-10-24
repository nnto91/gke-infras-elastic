resource "kubernetes_namespace" "elasticsearch" {
  metadata {
    name = "elasticsearch"
  }
}

resource "kubernetes_secret" "elastic_certificates" {
  metadata {
    name      = "elastic-certificates"
    namespace = kubernetes_namespace.elasticsearch.metadata.0.name
  }
  data = {
    "elastic-certificates.p12" = "${filebase64("./manifests/elastic-certificates.p12")}"
  }
  type = "generic"
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  chart      = "../helm-charts/elasticsearch"
  values = [
    "${file("./manifests/values-elastic.yaml")}"
  ]
  namespace  = kubernetes_namespace.elasticsearch.metadata.0.name
  timeout    = 600
  depends_on = [ kubernetes_namespace.elasticsearch ]
}
