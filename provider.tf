provider "google" {
}

provider "kubernetes" {
  host  = module.terraform-consul-gke.endpoint
  token = module.terraform-consul-gke.access_token

  cluster_ca_certificate = base64decode(
    module.terraform-consul-gke.cluster_ca_certificate
  )
}