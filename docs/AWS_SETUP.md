# AWS_SETUP.md

# AWS Setup Guide

> Complete AWS and GitHub configuration guide for the **GitHub Copilot Infrastructure Engineering Platform**.

This guide explains how to configure AWS, GitHub OIDC, IAM Roles, GitHub Secrets, GitHub Variables, and Terraform Backend for the **demo-serverless** project.

---

# Table of Contents

1. Architecture
2. Prerequisites
3. AWS Account Setup
4. Create GitHub OIDC Provider
5. Create IAM Role
6. Configure Trust Policy
7. Create IAM Permission Policy
8. Create Terraform Backend
9. Configure Terraform Backend
10. Configure GitHub Repository
11. GitHub Secrets
12. GitHub Variables
13. GitHub Environments
14. Workflow Permissions
15. Deployment Flow
16. Testing
17. Destroy Infrastructure
18. Verification Checklist
19. Troubleshooting
20. Security Best Practices

---

# 1. Architecture

```text
GitHub Repository

        │

        ▼

GitHub Actions

        │

        ▼

OIDC Authentication

        │

        ▼

IAM Role

        │

        ▼

Terraform

        │

        ▼

AWS Resources

├── S3

├── Lambda

├── DynamoDB

└── CloudWatch
```

---

# 2. Prerequisites

Required:

- AWS Account
- GitHub Repository
- Terraform 1.6+
- GitHub Actions Enabled

Repository:

```
infra-create-copilot-agent
```

Project:

```
demo-serverless
```

AWS Region:

```
ap-south-1
```

---

# 3. AWS Account Setup

Login using

```
Root User
```

The Root User is used **only once** for the initial configuration.

Never use:

- Root Access Key
- Root Secret Key

inside GitHub Actions.

---

# 4. Create GitHub OIDC Provider

Open

```
AWS Console

↓

IAM

↓

Identity Providers

↓

Add Provider
```

Provider Type

```
OpenID Connect
```

Provider URL

```
https://token.actions.githubusercontent.com
```

Audience

```
sts.amazonaws.com
```

Click

```
Add Provider
```

---

# Verify

You should see

```
token.actions.githubusercontent.com
```

listed under

```
IAM

↓

Identity Providers
```

---

# 5. Create GitHub Actions IAM Role

Open

```
IAM

↓

Roles

↓

Create Role
```

Trusted Entity

```
Web Identity
```

Identity Provider

```
token.actions.githubusercontent.com
```

Audience

```
sts.amazonaws.com
```

Role Name

```
GitHubActionsTerraformRole
```

Description

```
Terraform Deployment Role for GitHub Actions
```

---

# 6. Configure Trust Policy

Replace

```
ACCOUNT_ID

GITHUB_OWNER

REPOSITORY
```

with your values.

Example

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<GITHUB_OWNER>/<REPOSITORY>:*"
        }
      }
    }
  ]
}
```

Example

```
repo:soumen321/infra-create-copilot-agent:*
```

---

# Restrict to Main Branch (Recommended)

```json
"StringLike": {
  "token.actions.githubusercontent.com:sub":"repo:soumen321/infra-create-copilot-agent:ref:refs/heads/main"
}
```

---

# Restrict to GitHub Environment

```json
"StringLike": {
"token.actions.githubusercontent.com:sub":"repo:soumen321/infra-create-copilot-agent:environment:dev"
}
```

---

# 7. IAM Permission Policy

For this POC you may attach

```
AdministratorAccess
```

**only while learning**.

For production, use a custom least-privilege policy.

Example:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Lambda",
      "Effect": "Allow",
      "Action": ["lambda:*"],
      "Resource": "*"
    },

    {
      "Sid": "S3",
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": "*"
    },

    {
      "Sid": "DynamoDB",
      "Effect": "Allow",
      "Action": ["dynamodb:*"],
      "Resource": "*"
    },

    {
      "Sid": "CloudWatch",
      "Effect": "Allow",
      "Action": ["logs:*"],
      "Resource": "*"
    },

    {
      "Sid": "IAM",
      "Effect": "Allow",
      "Action": ["iam:*"],
      "Resource": "*"
    }
  ]
}
```

Attach policy to

```
GitHubActionsTerraformRole
```

---

# 8. Create Terraform Backend

## Create S3 Bucket

Example

```
demo-serverless-tfstate-123456
```

Enable

- Versioning
- Encryption
- Block Public Access

---

## Create DynamoDB Table

Table Name

```
terraform-lock
```

Partition Key

```
LockID
```

Type

```
String
```

Billing

```
On Demand
```

---

# 9. Configure Backend

backend.tf

```hcl
terraform {

backend "s3" {

bucket = "demo-serverless-tfstate-123456"

key = "demo-serverless/dev/terraform.tfstate"

region = "ap-south-1"

dynamodb_table = "terraform-lock"

encrypt = true

}

}
```

Initialize

```bash
terraform init
```

---

# 10. Configure GitHub Repository

Open

```
Repository

↓

Settings

↓

Secrets and Variables

↓

Actions
```

---

# 11. GitHub Secrets

Create

```
AWS_ROLE_TO_ASSUME
```

Value

```
arn:aws:iam::<ACCOUNT_ID>:role/GitHubActionsTerraformRole
```

---

# 12. GitHub Variables

Create

```
AWS_REGION
```

Value

```
ap-south-1
```

Create

```
TF_PROJECT
```

Value

```
demo-serverless
```

Create

```
TF_VERSION
```

Value

```
1.6.6
```

---

# 13. GitHub Environment

Create Environment

```
dev
```

Optional Protection Rules

- Required Reviewers
- Wait Timer
- Deployment Branch Policy

---

# 14. Workflow Permissions

Every entry workflow

```
ci.yml

deploy.yml

destroy.yml
```

must contain

```yaml
permissions:

contents: read

id-token: write
```

Reusable workflows

```
terraform-plan.yml

terraform-apply.yml

terraform-destroy.yml
```

also require

```yaml
permissions:

contents: read

id-token: write
```

---

# 15. Deployment Flow

```
Developer

↓

Git Push

↓

CI

↓

Terraform Validate

↓

Security Scan

↓

Developer

↓

Run Deploy Workflow

↓

Terraform Plan

↓

Terraform Apply

↓

AWS Infrastructure
```

---

# 16. Testing

Upload file

```bash
aws s3 cp sample.txt s3://<bucket-name>
```

Expected

```
S3

↓

Lambda Trigger

↓

Read File

↓

Store Item

↓

CloudWatch Logs
```

Verify

```
CloudWatch

↓

Lambda Logs
```

Verify

```
DynamoDB

↓

Explore Items
```

---

# 17. Destroy Infrastructure

GitHub

```
Actions

↓

Destroy Infrastructure

↓

Run Workflow
```

Execution

```
destroy.yml

↓

terraform-destroy.yml

↓

Terraform Destroy

↓

AWS Resources Deleted
```

---

# 18. Verification Checklist

## AWS

- [ ] OIDC Provider Created
- [ ] IAM Role Created
- [ ] Trust Policy Updated
- [ ] IAM Policy Attached
- [ ] Backend Bucket Created
- [ ] Lock Table Created

## GitHub

- [ ] Actions Enabled
- [ ] AWS_ROLE_TO_ASSUME Secret Added
- [ ] AWS_REGION Variable Added
- [ ] TF_PROJECT Variable Added
- [ ] TF_VERSION Variable Added

## Terraform

- [ ] terraform init
- [ ] terraform validate
- [ ] terraform plan
- [ ] terraform apply

## Deployment

- [ ] CI Passed
- [ ] Deploy Passed
- [ ] Lambda Created
- [ ] DynamoDB Created
- [ ] S3 Created

## Functional Test

- [ ] Upload File
- [ ] Lambda Triggered
- [ ] Item Stored
- [ ] CloudWatch Verified

---

# 19. Troubleshooting

| Error                     | Cause                      | Solution                                                 |
| ------------------------- | -------------------------- | -------------------------------------------------------- |
| AccessDenied              | IAM Policy                 | Verify attached permissions                              |
| AssumeRoleWithWebIdentity | Trust Policy               | Verify repository name and branch/environment conditions |
| No OIDC Token             | Missing `id-token: write`  | Add workflow permissions                                 |
| Backend Init Failed       | Missing S3/DynamoDB        | Create backend resources                                 |
| Lambda Not Triggered      | Missing Event Notification | Verify S3 notification configuration                     |
| DynamoDB AccessDenied     | Lambda IAM Role            | Update execution role policy                             |

---

# 20. Security Best Practices

- Never use AWS Access Keys in GitHub Actions.
- Use GitHub OIDC with temporary credentials.
- Scope trust policies to the specific repository and branch or environment.
- Enable S3 bucket versioning and server-side encryption.
- Use DynamoDB state locking.
- Separate CI, Deploy, and Destroy workflows.
- Review `terraform plan` before every apply.
- Follow least-privilege IAM principles in production.
- Protect production deployments with GitHub Environments and required reviewers.
- Enable CloudTrail and CloudWatch logging for auditing.

---

# Next Documents

Continue with:

- `GITHUB_ACTIONS_GUIDE.md`
- `COPILOT_SETUP.md`
- `TERRAFORM_GUIDE.md`
- `SERVERLESS_DEMO.md`
- `SECURITY_BEST_PRACTICES.md`
- `TROUBLESHOOTING.md`
