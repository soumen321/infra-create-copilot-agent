# Terraform Module Standards

Each AWS service must have its own module.

Example

modules/

lambda/

dynamodb/

s3/

iam/

kms/

cloudwatch/

vpc/

apigateway/

Each module contains

main.tf

variables.tf

outputs.tf

README.md

versions.tf

The module must not contain backend configuration.

The module must not contain environment-specific values.

The module must expose outputs for other modules.

Always keep modules reusable.
