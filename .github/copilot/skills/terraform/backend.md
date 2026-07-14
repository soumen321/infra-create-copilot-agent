# Backend Standard

Projects use remote backend.

Each environment has its own backend configuration.

Example

environments/

dev/

backend.hcl

terraform.tfvars

qa/

backend.hcl

terraform.tfvars

uat/

backend.hcl

terraform.tfvars

prod/

backend.hcl

terraform.tfvars

Never hardcode backend values.
