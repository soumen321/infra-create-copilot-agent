# Terraform Standards

Always

- Terraform >=1.6

Use

- variables.tf
- outputs.tf
- versions.tf
- providers.tf

Every resource must include

tags = {
Project = "Demo"
ManagedBy = "Terraform"
}

Always

terraform fmt

terraform validate

Follow

Least Privilege

Use Modules

Pin provider versions
