resource "kubernetes_namespace" "consul" {
  metadata {
    name = var.consul_namespace
  }
}

resource "helm_release" "consul" {
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com/"
  chart      = "consul"
  namespace  = kubernetes_namespace.consul.metadata.0.name

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
      datacenter                       = var.consul_datacenter,
      image_tag                        = var.consul_image_tag,
      manage_system_acls               = var.consul_manage_system_acls,
      replicas                         = var.initial_node_count,
      ui_enabled                       = var.consul_ui_enabled,
      ui_service_type                  = var.consul_service_type,
      connect_injected_enabled         = var.consul_connect_injected_enabled,
      connect_injected_enabled_default = var.consul_connect_injected_enabled_default,
      ingress_gateway_enabled          = var.consul_ingress_gateway_enabled,
      ingress_gateway_service_type     = var.consul_ingress_gateway_service_type
      ingress_gateway_name             = var.consul_ingress_gateway_name
    })
  ]
}