resource "kubernetes_namespace" "consul" {
  metadata {
    name = var.consul_namespace
  }
}

resource "helm_release" "consul" {
  name      = "consul"
  chart     = "consul-helm"
  namespace = kubernetes_namespace.consul.metadata.0.name

  values = [
    templatefile("${path.module}/consul/values.tmpl", {
      datacenter                       = var.consul_datacenter,
      replicas                         = var.initial_node_count,
      ui_enabled                       = var.consul_ui_enabled,
      connect_injected_enabled         = var.consul_connect_injected_enabled,
      connect_injected_enabled_default = var.consul_connect_injected_enabled_default
    })
  ]
}