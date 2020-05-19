resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}