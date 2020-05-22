module "terraform-consul-gke" {
  source = "./terraform-consul-gke"

  project_id                   = var.project_id
  cluster_name                 = var.cluster_name
  initial_node_count           = var.initial_node_count
  consul_service_type          = var.consul_service_type
  consul_image_tag             = var.consul_image_tag
  consul_enable_bootstrap_acls = var.consul_enable_bootstrap_acls
}