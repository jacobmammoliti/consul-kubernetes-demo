module "terraform-consul-gke" {
  source = "./terraform-consul-gke"

  cluster_name = var.cluster_name
}