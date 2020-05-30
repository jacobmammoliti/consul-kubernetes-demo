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
  default     = "consul:1.7.3"
}

variable "consul_enable_bootstrap_acls" {
  description = "controls wether or not to enable bootstrap ACLs within consul"
  default     = true
}

variable "consul_datacenter" {
  description = "datacenter name for consul"
  default     = "dc1"
}

variable "consul_ui_enabled" {
  description = "controls whether the ui is enabled for consul"
  default     = "true"
}

variable "consul_service_type" {
  description = "controls the type of service will be deployed for the consul ui"
  default     = "ClusterIP"
}

variable "consul_connect_injected_enabled" {
  description = "controls whether automatic connect sidecar injection will be enabled"
  default     = "true"
}

variable "consul_connect_injected_enabled_default" {
  description = "controls connect injection by default, otherwise requires annotation"
  default     = "false"
}

variable "consul_connect_k8s_deny_namespaces" {
  description = ""
  default     = []
  type        = list(string)
}

variable "consul_connect_k8s_allow_namespaces" {
  description = "list of kubernetes namespaces to allow Connect sidecar injection"
  default     = ["*"]
  type        = list(string)
}