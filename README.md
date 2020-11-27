# HashiCorp Consul and Kubernetes

![Validate Terraform](https://github.com/arctiqjacob/consul-kubernetes-demo/workflows/Validate%20Terraform/badge.svg?branch=master)

## Architecture
![architecture](consul.svg)

## Setup
```bash
# set path to google credentials
$ export GOOGLE_CREDENTIALS=<path_to_json>

# clone Consul helm chart
$ git clone git@github.com:hashicorp/consul-helm.git

# create a tfvars file
$ cat <<EOF > terraform.tfvars
project_id                     = "<redacted>"
cluster_name                   = "consul"
initial_node_count             = 3
consul_service_type            = "LoadBalancer"
preemptible                    = true
consul_ingress_gateway_enabled = true
EOF

# initialize terraform
$ terraform init
Initializing modules...
- terraform-consul-gke in terraform-consul-gke
...
Terraform has been successfully initialized!
...

# build kubernetes cluster with consul
$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
...
Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
...
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

connect = gcloud container clusters get-credentials consul --zone us-central1-a --project <redacted>
```

## Configure Consul DNS in Kubernetes with a stub-domain
```bash
# get the IP address of the DNS service
$ kubectl get svc consul-consul-dns -o jsonpath='{.spec.clusterIP}' -n consul
10.47.241.200

# create a ConfigMap to tell KubeDNS to use the Consul DNS
# service to resolve all domains ending with .consul
$ kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    addonmanager.kubernetes.io/mode: EnsureExists
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {"consul": ["10.47.241.200"]}
EOF
Warning: kubectl apply should be used on resource created by either kubectl create --save-config or kubectl apply
configmap/kube-dns configured
```

## Query Consul DNS
```bash
# create a k8s job to run a dig against a Consul enabled service
$ kubectl apply -f - <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: dig
spec:
  template:
    spec:
      containers:
        - name: dig
          image: anubhavmishra/tiny-tools
          command: ['dig', 'pokedex.service.arctiq.consul']
      restartPolicy: Never
  backoffLimit: 5
EOF

# get the name of the job
$ kubectl get pods
NAME        READY   STATUS      RESTARTS   AGE
dig-bbbsv   0/1     Completed   0          12s

# view the logs to verify we were able to discover the service
$ kubectl logs dig-bbbsv 
; <<>> DiG 9.11.2-P1 <<>> pokedex.service.arctiq.consul
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 19278
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;pokedex.service.arctiq.consul.    IN      A

;; ANSWER SECTION:
pokedex.service.arctiq.consul. 0   IN      A       10.44.1.7

;; Query time: 2 msec
;; SERVER: 10.47.240.10#53(10.47.240.10)
;; WHEN: Thu May 28 14:43:36 UTC 2020
;; MSG SIZE  rcvd: 71
```

## Deploying two Consul Clusters with WAN Federation and Mesh Gateway
This following example goes through deploying two separate GKE clusters with Consul deployed in both and joined via a Mesh Gateway. Note, when deploying the second GKE + Consul cluster the following variables will need to be updated:
- `consul_secondary_cluster` must be set to True

> Note: The Kubernetes pod and service CIDR blocks also must be different in each cluster.

Below are sample tfvars for each clusters.

`dc1.tfvars`
```HCL
cluster_name                     = "consul-east"
region                           = "us-east1-b"
project_id                       = <redacted>
initial_node_count               = 3
cluster_ipv4_cidr_block          = "192.168.0.0/21"
services_ipv4_cidr_block         = "192.168.8.0/24"
consul_datacenter                = "dc-east"
consul_connect_enabled           = true
consul_mesh_gateway_enabled      = true
consul_tls_enabled               = true
consul_federation_enabled        = true
consul_create_federation_secret  = true
preemptible                      = true
consul_gossip_encryption_enabled = true
```
`dc2.tfvars`
```HCL
cluster_name                     = "consul-west"
region                           = "us-west1-c"
project_id                       = <redacted>
initial_node_count               = 3
cluster_ipv4_cidr_block          = "192.168.9.0/21"
services_ipv4_cidr_block         = "192.168.16.0/24"
consul_datacenter                = "dc-west"
consul_connect_enabled           = true
consul_mesh_gateway_enabled      = true
consul_tls_enabled               = true
consul_federation_enabled        = true
consul_create_federation_secret  = false
preemptible                      = true
consul_gossip_encryption_enabled = true
consul_secondary_cluster         = true
```

The following steps can be followed to deploy the clusters.

```bash
# Generate a gossip key
$ export TF_VAR_consul_gossip_encryption_secret_value=`consul keygen`

# Deploy the first GKE cluster with Consul dc1
$ terraform apply -var-file=dc1.tfvars -auto-approve
...
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

connect = gcloud container clusters get-credentials consul-1 --zone us-central1-a --project <redacted>

# Authenticate to the GKE cluster
$ gcloud container clusters get-credentials consul-1 --zone us-central1-a --project <redacted>
Fetching cluster endpoint and auth data.
kubeconfig entry generated for consul-1.

# Retrieve the federation CA certificate
$ export TF_VAR_consul_tls_ca_certificate=`kubectl get secret consul-federation -n consul -o jsonpath={.data.caCert}`

# Retrieve the federation CA key
$ export TF_VAR_consul_tls_ca_key=`kubectl get secret consul-federation -n consul -o jsonpath={.data.caKey}`

# Retrieve the server configuration for the second cluster
$ export TF_VAR_consul_federation_config=`kubectl get secret consul-federation -n consul -o jsonpath={.data.serverConfigJSON}`

# Switch to a new Terraform workspace
$ terraform workspace select dc2
Switched to workspace "dc2".

# Deploy a second GKE cluster with Consul dc2
$ terraform apply -var-file=dc2.tfvars -auto-approve
...
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

connect = gcloud container clusters get-credentials consul-2 --zone us-central1-a --project <redacted>

# Authenticate to the GKE cluster
$ gcloud container clusters get-credentials consul-2 --zone us-central1-a --project <redacted>

# Verify the two Consul clusters have joined together via the Mesh Gateway
$ kubectl -n consul exec statefulset/consul-server -- consul members -wan
Node                 Address            Status  Type    Build  Protocol  DC   Segment
consul-server-0.dc1  10.32.2.6:8302     alive   server  1.8.3  2         dc1  <all>
consul-server-0.dc2  192.168.2.9:8302   alive   server  1.8.3  2         dc2  <all>
consul-server-1.dc1  10.32.0.11:8302    alive   server  1.8.3  2         dc1  <all>
consul-server-1.dc2  192.168.1.5:8302   alive   server  1.8.3  2         dc2  <all>
consul-server-2.dc1  10.32.1.9:8302     alive   server  1.8.3  2         dc1  <all>
consul-server-2.dc2  192.168.0.11:8302  alive   server  1.8.3  2         dc2  <all>
```

## Configuring the Ingress Gateway
The following steps go through setting up a sample 2 versioned application with the Ingress Gateway.

```bash
# Deploy the application
$ kubectl apply -f kubernetes/static-server.yaml
serviceaccount/static-server created
pod/static-server-v1 created
pod/static-server-v2 created

# Apply the ServiceSplitter, ServiceResolver, and ServiceDefaults CRD to send traffic to two versions of the application
$ kubectl apply -f kubernetes/consul-service.yaml
servicesplitter.consul.hashicorp.com/static-server created
servicedefaults.consul.hashicorp.com/static-server created
serviceresolver.consul.hashicorp.com/static-server created

# Apply the Ingress Gateway configuration entry
$ consul config write - <<EOF
Kind = "ingress-gateway"
Name = "ingress-service"

Listeners = [
 {
   Port = 8080
   Protocol = "http"
   Services = [
     {
       Name  = "static-server"
     }
   ]
 }
]
EOF
Config entry written: ingress-gateway/ingress-service

# curl the Ingress Gateway
$ curl -H 'Host: static-server.ingress.dc-east.consul' 104.196.19.59:8080
"v1"

$ curl -H 'Host: static-server.ingress.dc-east.consul' 104.196.19.59:8080
"v2"

# Apply the Ingress Gateway configuration entry with a custom host
$ consul config write - <<EOF
Kind = "ingress-gateway"
Name = "ingress-service"

Listeners = [
 {
   Port = 8080
   Protocol = "http"
   Services = [
     {
       Name  = "static-server"
       Hosts = ["static-server.104.196.19.59.nip.io"]
     }
   ]
 }
]
EOF
Config entry written: ingress-gateway/ingress-service

# curl the Ingress Gateway
$ curl http://static-server.104.196.19.59.nip.io:8080/ 
"v1"

$ curl http://static-server.104.196.19.59.nip.io:8080/
"v2"
```