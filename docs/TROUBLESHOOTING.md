# TROUBLESHOOTING.md

# Troubleshooting Guide

> Common issues, root causes, diagnostics, and fixes for the **GitHub Copilot Infrastructure Engineering Platform**

---

# Table of Contents

1. Introduction
2. General Troubleshooting Workflow
3. GitHub Copilot Issues
4. GitHub Actions Issues
5. OIDC Issues
6. IAM Issues
7. Terraform Issues
8. Backend Issues
9. S3 Issues
10. Lambda Issues
11. DynamoDB Issues
12. CloudWatch Issues
13. AWS CLI Issues
14. Git Issues
15. Deployment Issues
16. Destroy Issues
17. Verification Commands
18. Common Error Messages
19. Production Checklist

---

# 1. Introduction

This guide contains the most common issues encountered while working with:

- GitHub Copilot
- GitHub Actions
- Terraform
- AWS
- OIDC
- IAM
- Lambda
- S3
- DynamoDB

---

# 2. Troubleshooting Workflow

Always troubleshoot in this order:

```
Repository

↓

GitHub Actions

↓

OIDC

↓

Terraform

↓

AWS

↓

Application
```

Never start debugging Lambda code before verifying infrastructure.

---

# 3. GitHub Copilot Issues

## Copilot ignores Skills

### Symptoms

- Generic Terraform
- Wrong folder structure
- Doesn't use reusable workflows

### Verify

- SKILL.md exists
- Agent references Skill
- Templates exist
- Examples exist

### Fix

- Improve SKILL.md
- Add examples
- Add templates
- Update Agent instructions

---

## Copilot generates monolithic Terraform

### Cause

No Terraform Skill guidance.

### Fix

Teach Copilot

```
One AWS Service

↓

One Module
```

---

# 4. GitHub Actions Issues

## Workflow Not Visible

### Cause

Invalid YAML

### Verify

Actions Tab

↓

Workflow

### Fix

Validate YAML syntax.

---

## Workflow Doesn't Start

Verify

```
on:

push

pull_request

workflow_dispatch
```

Check

- branch name
- path filters
- repository Actions enabled

---

## Invalid Workflow

Example

```
Invalid workflow file
```

Cause

Bad indentation

Wrong YAML syntax

Unknown key

Fix

Validate YAML.

---

# 5. OIDC Issues

## Error

```
AssumeRoleWithWebIdentity
```

### Cause

Trust policy incorrect.

### Verify

Repository name

Branch

Environment

OIDC Provider

### Fix

Update Trust Policy.

---

## Error

```
id-token: none
```

### Cause

Missing permissions.

### Fix

Every caller workflow must include

```yaml
permissions:
  id-token: write
  contents: read
```

Also verify reusable workflows include the same permissions.

---

## Error

```
No OpenID Connect Token
```

### Verify

Repository

↓

Actions

↓

Workflow Permissions

OIDC Provider

IAM Role

---

# 6. IAM Issues

## AccessDenied

Cause

Missing IAM permissions.

### Verify

Attached Policies

Role ARN

Trust Policy

### Fix

Grant only required permissions.

---

## Lambda Cannot Access DynamoDB

Verify

Lambda Execution Role

↓

IAM Policy

↓

dynamodb:PutItem

---

## Lambda Cannot Read S3

Verify

```
s3:GetObject
```

permission.

---

# 7. Terraform Issues

## terraform init Failed

Verify

Backend Bucket

Backend Region

Bucket Exists

Credentials

---

## terraform validate Failed

Run

```bash
terraform fmt -recursive

terraform validate
```

---

## terraform plan Failed

Verify

```
terraform.tfvars
```

contains all required variables.

---

## terraform apply Failed

Run

```bash
terraform refresh
```

Review

Terraform Output

AWS Console

CloudTrail

---

## Terraform Destroy Failed

Cause

Resource Dependency

Example

```
Bucket Not Empty
```

Fix

Empty bucket

Run destroy again.

---

# 8. Backend Issues

## Backend Bucket Missing

Create

```
demo-serverless-tfstate
```

Enable

Versioning

Encryption

---

## State Lock Error

Example

```
ConditionalCheckFailedException
```

Verify

```
terraform-lock
```

table exists.

Remove stale lock only after confirming no active Terraform operation is running.

---

# 9. S3 Issues

## Lambda Not Triggered

Verify

```
Bucket Notification

↓

ObjectCreated
```

Target

```
Lambda
```

---

## Upload Successful But No Event

Verify

Lambda Permission

Bucket Notification

CloudWatch Logs

---

## Bucket Already Exists

Bucket names are globally unique.

Rename bucket.

---

# 10. Lambda Issues

## Lambda Timeout

Increase

```
timeout
```

Verify

CloudWatch Logs

---

## Module Import Error

Verify

Deployment Package

Runtime

Handler

---

## Handler Not Found

Example

```
Unable to import module
```

Verify

```
handler

runtime

filename
```

---

## Lambda Permission Error

Verify

IAM Role

↓

Execution Policy

---

## Environment Variables Missing

Verify

Terraform

↓

Lambda Module

↓

environment_variables

---

# 11. DynamoDB Issues

## PutItem Failed

Verify

```
TABLE_NAME
```

environment variable.

Verify IAM permissions.

---

## Resource Not Found

Verify

Table Name

Region

AWS Account

---

## ValidationException

Verify

Partition Key

Attribute Types

---

# 12. CloudWatch Issues

## No Logs

Verify

Lambda Role contains

```
logs:CreateLogGroup

logs:CreateLogStream

logs:PutLogEvents
```

---

## Log Group Missing

Invoke Lambda once.

CloudWatch Log Group is created on first invocation unless managed separately.

---

# 13. AWS CLI Issues

## Credentials Error

Check

```bash
aws configure list
```

Verify

```bash
aws sts get-caller-identity
```

---

## Wrong Region

Verify

```bash
aws configure get region
```

---

## Upload File

```bash
aws s3 cp sample.txt s3://bucket-name
```

---

# 14. Git Issues

## Push Rejected

Run

```bash
git pull --rebase
```

Resolve conflicts

Push again.

---

## Wrong Branch

Verify

```bash
git branch
```

---

## GitHub Actions Not Triggered

Verify

```
push:

branches:

- main
```

---

# 15. Deployment Issues

Deployment order

```
Push

↓

CI

↓

Security Scan

↓

Deploy

↓

Terraform Plan

↓

Terraform Apply
```

Never run Apply before Plan.

---

## Deployment Failed

Review

Actions

↓

Job Logs

↓

Terraform Output

↓

AWS Console

---

# 16. Destroy Issues

## Destroy Workflow Failed

Verify

```
terraform-destroy.yml
```

has

```yaml
permissions:
  id-token: write
```

---

## Bucket Not Empty

Delete objects.

Run destroy again.

---

## IAM Role Still Exists

Terraform cannot delete roles still attached to resources.

Delete dependent resources first.

---

# 17. Verification Commands

AWS Identity

```bash
aws sts get-caller-identity
```

Current Region

```bash
aws configure get region
```

Terraform Version

```bash
terraform version
```

Validate

```bash
terraform validate
```

Plan

```bash
terraform plan
```

Destroy

```bash
terraform destroy
```

Git Status

```bash
git status
```

Workflow Logs

```
GitHub

↓

Actions

↓

Workflow

↓

Job Logs
```

---

# 18. Common Error Messages

| Error                           | Root Cause                    | Resolution                              |
| ------------------------------- | ----------------------------- | --------------------------------------- |
| AccessDenied                    | IAM policy                    | Review permissions                      |
| AssumeRoleWithWebIdentity       | Trust policy                  | Verify OIDC configuration               |
| id-token: none                  | Missing workflow permissions  | Add `id-token: write`                   |
| Invalid workflow                | YAML syntax                   | Validate YAML                           |
| terraform init failed           | Backend issue                 | Verify S3 bucket and DynamoDB table     |
| terraform validate failed       | Invalid configuration         | Run `terraform fmt` and review syntax   |
| BucketAlreadyExists             | Global namespace              | Choose a unique bucket name             |
| NoSuchBucket                    | Bucket missing                | Create or correct bucket name           |
| Lambda timeout                  | Timeout too low               | Increase timeout                        |
| Handler not found               | Incorrect handler             | Verify handler path                     |
| ResourceNotFoundException       | Wrong resource name or region | Verify Terraform outputs and AWS region |
| ConditionalCheckFailedException | Terraform state lock          | Check DynamoDB lock table               |
| ModuleNotFoundError             | Missing dependency            | Package dependencies correctly          |

---

# 19. Debugging Checklist

## GitHub

- [ ] Repository exists
- [ ] Actions enabled
- [ ] Branch correct

## OIDC

- [ ] Identity Provider created
- [ ] Trust policy correct
- [ ] IAM Role exists
- [ ] Workflow has `id-token: write`

## Terraform

- [ ] Backend initialized
- [ ] Variables provided
- [ ] Validation passed
- [ ] Plan generated

## AWS

- [ ] Lambda deployed
- [ ] S3 bucket created
- [ ] DynamoDB table created
- [ ] IAM role attached

## Runtime

- [ ] Upload file to S3
- [ ] Lambda invoked
- [ ] CloudWatch logs generated
- [ ] DynamoDB item created

---

# 20. Recovery Procedure

If the deployment becomes inconsistent:

1. Check GitHub Actions logs.
2. Verify AWS identity using `aws sts get-caller-identity`.
3. Confirm Terraform backend access.
4. Run `terraform plan` to inspect drift.
5. Resolve resource conflicts.
6. Re-run deployment if appropriate.
7. If the environment is no longer needed, run the destroy workflow and redeploy from a clean state.

---

# 21. Escalation Guide

If an issue cannot be resolved through the above steps:

1. Review GitHub Actions logs.
2. Review Terraform logs.
3. Review CloudWatch Logs.
4. Review CloudTrail events.
5. Compare the deployed infrastructure with the Terraform state.
6. Check recent repository changes before making additional modifications.

---

# Summary

Following this troubleshooting guide should help identify and resolve the majority of issues encountered while using this project.

The recommended troubleshooting order is:

```text
GitHub Repository

↓

GitHub Actions

↓

OIDC Authentication

↓

IAM

↓

Terraform

↓

AWS Resources

↓

Application Logic
```

Working from the outside in helps isolate configuration issues before investigating application code.
