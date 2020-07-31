provider "google" {
}

provider "kubernetes" {
  load_config_file = "false"
  host             = module.terraform-consul-gke.endpoint
  token            = module.terraform-consul-gke.access_token

  cluster_ca_certificate = base64decode(
    module.terraform-consul-gke.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    load_config_file = "false"
    host             = module.terraform-consul-gke.endpoint
    token            = module.terraform-consul-gke.access_token

    cluster_ca_certificate = base64decode(
      module.terraform-consul-gke.cluster_ca_certificate
    )
  }
}