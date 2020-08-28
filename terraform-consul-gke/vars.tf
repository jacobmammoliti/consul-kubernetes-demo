variable "project_id" {
  description = "id of project to deploy kubernetes cluster into"
}

variable "cluster_name" {
  description = "name given to kubernetes cluster"
}

variable "location" {
  description = "location to deploy kubernetes cluster into"
  default     = "us-central1-a"
}

variable "initial_node_count" {
  description = "inital node count for kubernetes cluster"
  default     = "1"
}

variable "network" {
  description = "network where kubernetes nodes will live in"
  default     = "default"
}

variable "oauth_scopes" {
  description = "list of oauth scopes kubernetes nodes has"
  default = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring"
  ]
  type = list
}

variable "machine_type" {
  description = "compute resource type that each kubernetes node will live on"
  default     = "n1-standard-1"
}

variable "preemptible" {
  description = "controls whether kubernetes nodes should be preemtible or not"
  default     = true
}

variable "consul_namespace" {
  description = "kubernetes namespace to deploy consul into"
  default     = "consul"
}

variable "consul_image_tag" {
  description = "controls the consul docker image tag to pull"
  default     = "consul:1.8.0"
}

variable "consul_tls_enabled" {
  type        = bool
  description = "enables tls in the consul mesh"
  default     = false
}

variable "consul_federation_enabled" {
  type        = bool
  description = "enables federation in the consul mesh"
  default     = false
}

variable "consul_create_federation_secret" {
  type        = bool
  description = "tells consul to create a federation secret"
  default     = false
}

variable "consul_manage_system_acls" {
  description = "controls wether or not to enable bootstrap ACLs within consul"
  default     = false
}

variable "consul_connect_enabled" {
  description = "controls wether or not to enable Connect"
  default     = true
}

variable "consul_gossip_encryption_secret_name" {
  description = "secret name for kubernetes gossip secret name"
  default     = "consul-gossip-encryption-key"
}

variable "consul_gossip_encryption_secret_key" {
  description = "secret name for kubernetes gossip secret key"
  default     = "key"
}

variable "consul_datacenter" {
  description = "datacenter name for consul"
  default     = "dc1"
}

variable "consul_ui_enabled" {
  description = "controls whether the ui is enabled for consul"
  default     = true
}

variable "consul_service_type" {
  description = "controls the type of service will be deployed for the consul ui"
  default     = "ClusterIP"
}

variable "consul_connect_injected_enabled" {
  description = "controls whether automatic connect side injection will be enabled"
  default     = true
}

variable "consul_connect_injected_enabled_default" {
  description = "controls connect injection by default, otherwise requires annotation"
  default     = false
}

variable "consul_mesh_gateway_enabled" {
  type        = bool
  description = "enables the consul mesh gateway"
  default     = false
}

variable "consul_ingress_gateway_enabled" {
  description = "controls whether to enable the consul ingress gateway"
  default     = false
}

variable "consul_ingress_gateway_service_type" {
  description = "controls the type of kubernetes service to assign the ingress gateway"
  default     = "ClusterIP"
}

variable "consul_ingress_gateway_name" {
  description = "controls the name of the ingress gateway in Consul"
  default     = "ingress-service"
<<<<<<< HEAD
}
=======
}
>>>>>>> 93bd0dfee5387fee9328253f6a0505ba1fb80aba
