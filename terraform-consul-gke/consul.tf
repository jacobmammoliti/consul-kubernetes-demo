resource "kubernetes_namespace" "consul" {
  metadata {
    name = var.consul_namespace
  }
}

resource "helm_release" "consul" {
  name       = var.consul_name
  repository = "https://helm.releases.hashicorp.com/"
  chart      = "consul"
  namespace  = kubernetes_namespace.consul.metadata.0.name

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
      name                             = var.consul_name,
      datacenter                       = var.consul_datacenter,
      image_tag                        = var.consul_image_tag,
      tls_enabled                      = var.consul_tls_enabled,
      gossip_encryption_enabled        = var.consul_gossip_encryption_enabled,
      gossip_encryption_secret_name    = var.consul_gossip_encryption_secret_name,
      gossip_enryption_secret_key      = var.consul_gossip_encryption_secret_key,
      federation_enabled               = var.consul_federation_enabled,
      create_federation_secret         = var.consul_create_federation_secret,
      manage_system_acls               = var.consul_manage_system_acls,
      replicas                         = var.initial_node_count,
      connect_enabled                  = var.consul_connect_enabled,
      ui_enabled                       = var.consul_ui_enabled,
      ui_service_type                  = var.consul_service_type,
      connect_injected_enabled         = var.consul_connect_injected_enabled,
      connect_injected_enabled_default = var.consul_connect_injected_enabled_default,
      mesh_gateway_enabled             = var.consul_mesh_gateway_enabled,
      ingress_gateway_enabled          = var.consul_ingress_gateway_enabled,
      ingress_gateway_service_type     = var.consul_ingress_gateway_service_type,
      ingress_gateway_name             = var.consul_ingress_gateway_name,
      consul_secondary_cluster         = var.consul_secondary_cluster
    })
  ]

  depends_on = [kubernetes_secret.gossip_encryption_secret]
}

resource "kubernetes_secret" "gossip_encryption_secret" {
  count = var.consul_gossip_encryption_enabled ? 1 : 0

  metadata {
    name      = var.consul_gossip_encryption_secret_name
    namespace = var.consul_namespace
  }

  data = {
    "${var.consul_gossip_encryption_secret_key}" = var.consul_gossip_encryption_secret_value
  }
}

resource "kubernetes_secret" "consul_federation" {
  count = var.consul_secondary_cluster ? 1 : 0

  metadata {
    name      = "consul-federation"
    namespace = var.consul_namespace
  }

  data = {
    caCert           = base64decode(var.consul_tls_ca_certificate)
    caKey            = base64decode(var.consul_tls_ca_key)
    serverConfigJSON = base64decode(var.consul_federation_config)
  }
}