resource "kubernetes_namespace" "fulltext" {
  metadata {
    name = "fulltext"
  }
  depends_on = [ null_resource.apply_policy_hosts ]
}

resource "helm_release" "es_fulltext" {
  name       = "es-fulltext"
  chart      = "./charts/elasticsearch"
  values = [
    "${file("./manifests/values-elastic-fulltext.yaml")}"
  ]
  namespace  = kubernetes_namespace.fulltext.metadata.0.name
  timeout    = 600
  depends_on = [ kubernetes_namespace.fulltext ]
}

resource "helm_release" "kibana_fulltext" {
  name       = "kibana-fulltext"
  chart      = "./charts/kibana"
  values = [
    "${file("./manifests/values-kibana-fulltext.yaml")}"
  ]
  namespace  = kubernetes_namespace.fulltext.metadata.0.name
  timeout    = 600
  depends_on = [ helm_release.es_fulltext ]
}

resource "null_resource" "apply_kibana_fulltext_vs" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./manifests/kibana-fulltext-vs.yaml -n ${kubernetes_namespace.fulltext.metadata.0.name}"
    environment = {
      KUBECONFIG = "${path.module}/kubeconfig"
    }
  }
  depends_on = [ helm_release.kibana_fulltext ]
}