resource "google_container_cluster" "kubernetes_cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  initial_node_count = var.initial_node_count
  network            = var.network

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

  node_config {
    oauth_scopes = var.oauth_scopes

    metadata = {
      disable-legacy-endpoints = "true"
    }

    machine_type = var.machine_type
    preemptible  = var.preemptible
  }
}