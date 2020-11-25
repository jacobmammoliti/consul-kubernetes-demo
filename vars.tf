variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster (required)"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in (required)"
  default     = "us-central1-a"
}

variable "initial_node_count" {
  type        = number
  description = "The number of nodes to create in this cluster's default node pool (required)"
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in (required)"
  default     = "default"
}

variable "cluster_ipv4_cidr_block" {
  type        = string
  description = "The IP address range for the cluster pod IPs"
  default     = "192.168.0.0/16"
}

variable "services_ipv4_cidr_block" {
  type        = string
  description = "The IP address range of the services IPs in this cluster"
  default     = "10.96.0.0/12"
}

variable "oauth_scopes" {
  type        = list(string)
  description = "Map of lists containing node oauth scopes by node-pool name"
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "machine_type" {
  type        = string
  description = "The GCE type that each of the cluster's nodes will be"
  default     = "n1-standard-2"
}

variable "preemptible" {
  type        = bool
  description = "Specifies if the nodes should be preemptible or not"
  default     = true
}

variable "consul_name" {
  type        = string
  description = "Specifies the name of the Consul deployment"
  default     = "consul"
}

variable "consul_namespace" {
  type        = string
  description = "The namespace that Consul will be deployed into"
  default     = "consul"
}

variable "consul_image_tag" {
  type        = string
  description = "The tag of the Consul docker image to pull"
  default     = "consul:1.9.0"
}

variable "consul_tls_enabled" {
  type        = bool
  description = "Enables TLS across the Consul cluster to verify authenticity of servers and clients that connect"
  default     = false
}

variable "consul_gossip_encryption_enabled" {
  type        = bool
  description = "Enables gossip encryption across the Consul cluster"
  default     = false
}

variable "consul_gossip_encryption_secret_name" {
  type        = string
  description = "The name of the Kubernetes secret that contains the gossip encryption key"
  default     = "consul-gossip-encryption-key"
}

variable "consul_gossip_encryption_secret_value" {
  type        = string
  description = "The value of the key within the Kubernetes secret that holds the gossip encryption key"
  default     = ""
}

variable "consul_tls_ca_certificate" {
  type        = string
  description = "The certificate of the CA to use for TLS communication within the Consul cluster"
  default     = ""
}

variable "consul_tls_ca_key" {
  type        = string
  description = "The private key of the CA to use for TLS communication within the Consul cluster"
  default     = ""
}

variable "consul_federation_enabled" {
  type        = bool
  description = "Enables federation on the Consul cluster"
  default     = false
}

variable "consul_create_federation_secret" {
  type        = bool
  description = "Creates a Consul federation Kubernetes secret"
  default     = false
}

variable "consul_manage_system_acls" {
  type        = bool
  description = "Whether or not to enable bootstrap ACLs within Consul"
  default     = false
}

variable "consul_connect_enabled" {
  type        = bool
  description = "Whether or not to enable Consul Connect"
  default     = true
}

variable "consul_datacenter" {
  type        = string
  description = "The name of the Consul datacenter"
  default     = "dc1"
}

variable "consul_ui_enabled" {
  type        = bool
  description = "Specifies if the UI should be enabled in Consul"
  default     = true
}

variable "consul_service_type" {
  type        = string
  description = "Specifies the Kubernetes service type for the Consul UI service"
  default     = "ClusterIP"
}

variable "consul_connect_injected_enabled" {
  type        = bool
  description = "Whether or not to enable Consul Connect sidecar injection"
  default     = true
}

variable "consul_connect_injected_enabled_default" {
  type        = bool
  description = "Whether or not to enable Consul Connect injection by default (otherwise requires annotation)"
  default     = false
}

variable "consul_mesh_gateway_enabled" {
  type        = bool
  description = "Whether or not to enable the Consul Mesh Gateway"
  default     = false
}

variable "consul_ingress_gateway_enabled" {
  type        = bool
  description = "Whether or not to enable the Consul Ingress Gateway"
  default     = false
}

variable "consul_ingress_gateway_service_type" {
  type        = string
  description = "Specifies the Kubernetes service type for the Consul Ingress Gateway"
  default     = "LoadBalancer"
}

variable "consul_ingress_gateway_name" {
  type        = string
  description = "Specifies the name of the Consul Ingress Gateway"
  default     = "ingress-service"
}

variable "consul_secondary_cluster" {
  type        = bool
  description = "Flags this Consul cluster as secondary (for WAN federation)"
  default     = false
}

variable "consul_federation_config" {
  type        = string
  description = "Defines the primary Consul Server configuration in JSON format (for WAN federation)"
  default     = ""
}

variable "consul_controller_enabled" {
  type        = bool
  description = "Specifies whether Consul CRDs should be enabled in the cluster"
  default     = true
}