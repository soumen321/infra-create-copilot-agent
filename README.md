# GitHub Copilot Infrastructure Engineering Platform

> Enterprise implementation guide for building reusable GitHub Copilot
> Agents, Skills, Instructions, GitHub Actions, and modular Terraform.

---

# Architecture

```text
Developer
    │
    ▼
GitHub Copilot Agent
    │
    ▼
Skills + Instructions
    │
    ▼
Generate Terraform + GitHub Actions
    │
    ▼
Git Push
    │
    ▼
CI
 ├── terraform fmt
 ├── terraform validate
 └── security scan
    │
Manual Deploy
    │
    ▼
terraform-plan
    │
    ▼
terraform-apply
    │
    ▼
AWS
 ├── S3
 ├── Lambda
 └── DynamoDB
    │
Upload File
    │
    ▼
Lambda
    │
    ▼
DynamoDB
```

# Repository Structure

```text
.github/
├── copilot/
│   ├── agents/
│   ├── instructions/
│   ├── skills/
│   ├── hooks/
│   ├── plugins/
│   └── extensions/
└── workflows/
    ├── ci.yml
    ├── deploy.yml
    ├── terraform-plan.yml
    ├── terraform-apply.yml
    ├── terraform-destroy.yml
    └── security-scan.yml

terraform/
├── modules/
├── projects/demo-serverless/
└── environments/dev/

src/lambda_function/
docs/
scripts/
```

# Step 1 - Build Copilot Repository

Create the repository structure above.

Validation: - All folders exist. - Copilot detects `.github/copilot`.

# Step 2 - Instructions

Create:

- coding.instructions.md
- terraform.instructions.md
- github-actions.instructions.md
- aws.instructions.md

Validation: Ask Copilot to generate Terraform and confirm it follows
your standards.

# Step 3 - Skills

Create skills:

- Terraform
- GitHub Actions
- AWS
- Security

Each skill contains:

- SKILL.md
- examples/
- templates/

Validation: Prompt: \> Create an S3 module.

The generated code should match the templates.

# Step 4 - Agent

Create `infrastructure-agent.md`.

Responsibilities:

- Select proper skills
- Generate reusable workflows
- Generate modular Terraform
- Follow instructions

Validation:

Prompt:

> Use Infrastructure Engineering Agent. Create demo-serverless.

# Step 5 - Generate Project

Expected modules:

- S3
- Lambda
- IAM
- DynamoDB

Project:

    terraform/projects/demo-serverless

Validation:

    terraform fmt -recursive
    terraform validate

# Step 6 - AWS Setup

Using the AWS console:

1.  Create GitHub OIDC Provider
2.  Create GitHub IAM Role
3.  Configure Trust Policy
4.  Create backend S3 bucket
5.  Create DynamoDB lock table

# Step 7 - GitHub Repository Setup

Secrets:

- AWS_ROLE_TO_ASSUME

Variables:

- AWS_REGION
- TF_PROJECT
- TF_VERSION

# Step 8 - Local Validation

```bash
cd terraform/projects/demo-serverless

terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file=../../environments/dev/terraform.tfvars -out=tfplan
terraform apply tfplan
```

Upload:

```bash
aws s3 cp sample.txt s3://<bucket>
```

Verify:

- CloudWatch Logs
- DynamoDB Items

Destroy:

```bash
terraform destroy -var-file=../../environments/dev/terraform.tfvars
```

# Step 9 - GitHub Actions

## CI

Trigger:

- Push
- Pull Request

Flow:

    ci.yml
       ↓
    Terraform Format
       ↓
    Terraform Validate
       ↓
    security-scan.yml

## Deploy

Trigger:

Actions → Deploy → Run workflow

Flow:

    deploy.yml
          ↓
    terraform-plan.yml
          ↓
    terraform-apply.yml

## Destroy

Trigger:

Actions → Destroy Infrastructure

Flow:

    destroy.yml
          ↓
    terraform-destroy.yml

# End-to-End Test

1.  Deploy infrastructure.
2.  Upload sample.txt.
3.  S3 triggers Lambda.
4.  Lambda reads file.
5.  Lambda writes file contents to DynamoDB.
6.  Verify CloudWatch Logs.
7.  Destroy infrastructure.

# Troubleshooting

- OIDC: verify `id-token: write` and IAM trust policy.
- Terraform init: verify backend configuration.
- Lambda: check CloudWatch Logs.
- S3 events: verify bucket notifications.
- DynamoDB: verify IAM permissions.

# Best Practices

- Use reusable GitHub workflows.
- Keep Terraform modules independent.
- Never hardcode AWS credentials.
- Use OIDC.
- Validate locally before deployment.
- Keep CI and Deploy separate.
- Review plans before apply.
- Destroy POC infrastructure after testing.

# Success Checklist

- [ ] Copilot folders created
- [ ] Instructions created
- [ ] Skills created
- [ ] Agent created
- [ ] Terraform generated
- [ ] Local validation successful
- [ ] AWS OIDC configured
- [ ] GitHub secrets configured
- [ ] CI passed
- [ ] Deploy passed
- [ ] Lambda triggered
- [ ] DynamoDB updated
- [ ] Destroy completed
