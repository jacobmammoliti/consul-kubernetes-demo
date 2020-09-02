module "terraform-consul-gke" {
  source = "./terraform-consul-gke"

  project_id                            = var.project_id
  cluster_name                          = var.cluster_name
  cluster_ipv4_cidr_block               = var.cluster_ipv4_cidr_block
  services_ipv4_cidr_block              = var.services_ipv4_cidr_block
  consul_name                           = var.consul_name
  consul_datacenter                     = var.consul_datacenter
  initial_node_count                    = var.initial_node_count
  consul_tls_enabled                    = var.consul_tls_enabled
  consul_tls_ca_certificate             = var.consul_tls_ca_certificate
  consul_tls_ca_key                     = var.consul_tls_ca_key
  consul_gossip_encryption_enabled      = var.consul_gossip_encryption_enabled
  consul_gossip_encryption_secret_value = var.consul_gossip_encryption_secret_value
  consul_federation_enabled             = var.consul_federation_enabled
  consul_create_federation_secret       = var.consul_create_federation_secret
  consul_federation_config              = var.consul_federation_config
  consul_service_type                   = var.consul_service_type
  preemptible                           = var.preemptible
  machine_type                          = var.machine_type
  consul_manage_system_acls             = var.consul_manage_system_acls
  consul_ingress_gateway_enabled        = var.consul_ingress_gateway_enabled
  consul_mesh_gateway_enabled           = var.consul_mesh_gateway_enabled
  consul_secondary_cluster              = var.consul_secondary_cluster
}