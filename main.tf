module "terraform-consul-gke" {
  source = "./terraform-consul-gke"

  project_id                      = var.project_id
  cluster_name                    = var.cluster_name
  initial_node_count              = var.initial_node_count
  consul_tls_enabled              = var.consul_tls_enabled
  consul_federation_enabled       = var.consul_federation_enabled
  consul_create_federation_secret = var.consul_create_federation_secret
  consul_service_type             = var.consul_service_type
  preemptible                     = var.preemptible
  machine_type                    = var.machine_type
  consul_manage_system_acls       = var.consul_manage_system_acls
  consul_ingress_gateway_enabled  = var.consul_ingress_gateway_enabled
  consul_mesh_gateway_enabled     = var.consul_mesh_gateway_enabled
}