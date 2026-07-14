# Enterprise Terraform Repository Structure

All infrastructure must follow this repository layout.

terraform/

├── projects/
│
│ └── <project-name>/
│ ├── providers.tf
│ ├── versions.tf
│ ├── variables.tf
│ ├── outputs.tf
│ ├── locals.tf
│ ├── data.tf
│ ├── main.tf
│ ├── backend.tf
│ └── README.md
│
├── modules/
│
│ ├── lambda/
│ ├── dynamodb/
│ ├── s3/
│ ├── iam/
│ ├── kms/
│ ├── apigateway/
│ ├── cloudwatch/
│ ├── security-group/
│ ├── vpc/
│ └── ...
│
├── environments/
│
│ ├── dev/
│ ├── qa/
│ ├── uat/
│ └── prod/
│
└── shared/
├── locals.tf
├── variables.tf
└── tags.tf

---

## Rules

Never place all resources in one main.tf.

Always use reusable modules.

Every AWS service should have its own module.

Every project must consume modules.

Never duplicate resources.

Modules must remain generic.

Projects contain business-specific composition.

Environment folders contain tfvars and backend configuration only.
