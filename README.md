# HashiCorp Consul and Kubernetes

## Setup
```shell
$ export GOOGLE_CREDENTIALS=<path_to_json>
$ export GOOGLE_PROJECT=<google_project_id>

$ terraform init
Initializing modules...
- terraform-consul-gke in terraform-consul-gke
...
Terraform has been successfully initialized!
...

$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
...
Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
...
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```