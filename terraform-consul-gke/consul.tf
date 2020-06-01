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
      image_tag                        = var.consul_image_tag,
      enable_bootstrap_acls            = var.consul_enable_bootstrap_acls,
      replicas                         = var.initial_node_count,
      ui_enabled                       = var.consul_ui_enabled,
      service_type                     = var.consul_service_type,
      connect_injected_enabled         = var.consul_connect_injected_enabled,
      connect_injected_enabled_default = var.consul_connect_injected_enabled_default,
      k8s_deny_namespaces              = join(", ", var.consul_connect_k8s_deny_namespaces),
      k8s_allow_namespaces             = join(", ", var.consul_connect_k8s_allow_namespaces)
    })
  ]
}