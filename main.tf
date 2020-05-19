module "terraform-consul-gke" {
  source = "./terraform-consul-gke"

  project_id   = var.project_id
  cluster_name = var.cluster_name
}