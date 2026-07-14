# SECURITY_BEST_PRACTICES.md

# Security Best Practices Guide

> Enterprise Security Guide for the GitHub Copilot Infrastructure Engineering Platform

Version: 1.0

---

# Table of Contents

1. Security Overview
2. Shared Responsibility Model
3. Identity & Access Management
4. GitHub OIDC Authentication
5. IAM Best Practices
6. Least Privilege Principle
7. Terraform Security
8. GitHub Actions Security
9. Secrets Management
10. S3 Security
11. Lambda Security
12. DynamoDB Security
13. CloudWatch Security
14. Logging & Monitoring
15. Repository Security
16. CI/CD Security
17. Supply Chain Security
18. Security Checklist
19. Common Security Mistakes
20. Production Recommendations

---

# 1. Security Overview

This repository follows the following security principles.

- Zero long-lived credentials
- OIDC authentication
- Infrastructure as Code
- Least Privilege
- Immutable Infrastructure
- Security by Default

---

# 2. Security Architecture

```text
Developer

↓

GitHub

↓

OIDC Token

↓

IAM Role

↓

Temporary Credentials

↓

Terraform

↓

AWS Resources
```

No AWS Access Keys are stored inside GitHub.

---

# 3. Shared Responsibility

AWS Secures

- Physical Infrastructure
- Networking
- Hardware
- Hypervisor

You Secure

- IAM
- Terraform
- GitHub
- Secrets
- Lambda Code
- Bucket Policies

---

# 4. Identity Management

Always use IAM Roles.

Never use

- Root User
- IAM User Access Keys
- Hardcoded Credentials

Recommended

```
GitHub

↓

OIDC

↓

IAM Role

↓

Terraform
```

---

# 5. GitHub OIDC

Instead of

```
AWS_ACCESS_KEY

AWS_SECRET_KEY
```

Use

```
GitHub OIDC

↓

AssumeRoleWithWebIdentity
```

Advantages

- Temporary Credentials
- Automatic Rotation
- No Secret Storage
- Enterprise Standard

---

# 6. IAM Role

GitHub Actions should assume

```
GitHubActionsTerraformRole
```

Never attach AdministratorAccess in production.

Use custom policies.

---

# 7. Trust Policy

Recommended

```json
{
  "Condition": {
    "StringLike": {
      "token.actions.githubusercontent.com:sub": "repo:OWNER/REPOSITORY:ref:refs/heads/main"
    }
  }
}
```

Even better

```
Environment Protected Branch
```

---

# 8. Least Privilege

Grant only required permissions.

Example

Instead of

```
lambda:*
```

Use

```
CreateFunction

UpdateFunctionCode

GetFunction

DeleteFunction
```

Same principle for

- S3
- DynamoDB
- CloudWatch

---

# 9. IAM Policy Design

Separate policies

```
Lambda Policy

S3 Policy

CloudWatch Policy

DynamoDB Policy

Terraform Backend Policy
```

Avoid

```
One Huge Policy
```

---

# 10. GitHub Secrets

Secrets should contain

```
AWS_ROLE_TO_ASSUME
```

Do NOT store

```
AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY
```

---

# 11. GitHub Variables

Use Variables for

```
AWS_REGION

TF_VERSION

TF_PROJECT
```

Never store sensitive values in Variables.

---

# 12. GitHub Environments

Recommended

```
dev

qa

uat

prod
```

Protect

Production

with

- Required Reviewers
- Deployment Approval
- Branch Restrictions

---

# 13. GitHub Workflow Permissions

Always define

```yaml
permissions:

contents: read

id-token: write
```

Avoid

```yaml
permissions: write-all
```

---

# 14. Third-Party GitHub Actions

Pin actions by version.

Preferred

```yaml
actions/checkout@v4
```

Better

Pin to commit SHA for maximum supply-chain security.

Avoid

```
@main

@master

@latest
```

---

# 15. Terraform Security

Always run

```
terraform fmt

terraform validate

terraform plan
```

before

```
terraform apply
```

Use

```
tfsec

checkov

terrascan
```

inside CI.

---

# 16. Terraform State

Never commit

```
terraform.tfstate
```

Store remotely

```
S3 Backend
```

Enable

- Encryption
- Versioning

Lock state

```
DynamoDB
```

---

# 17. S3 Security

Enable

- Versioning
- Encryption
- Block Public Access

Avoid

```
Public Read Bucket
```

Recommended Encryption

```
AES256

or

AWS KMS
```

---

# 18. Bucket Policies

Grant access only to

```
Lambda

Terraform

Required Services
```

Never use

```
Principal = *
```

unless intentionally public.

---

# 19. Lambda Security

Use

Dedicated IAM Role

Environment Variables

CloudWatch Logging

Never

Hardcode Credentials

---

# 20. Lambda Environment Variables

Good

```
TABLE_NAME

BUCKET_NAME
```

Bad

```
Passwords

API Keys

Database Passwords
```

Use

AWS Secrets Manager

or

SSM Parameter Store

for sensitive values.

---

# 21. DynamoDB Security

Recommended

Encryption

Point-in-Time Recovery (Production)

Least Privilege IAM

Avoid

```
dynamodb:*
```

---

# 22. CloudWatch

Enable

Logs

Metrics

Retention Policy

Avoid

Infinite Log Retention

---

# 23. Logging

Log

- Request ID
- Resource Name
- Execution Time
- Errors

Never log

- Passwords
- Secrets
- Tokens
- Credentials

---

# 24. CI/CD Security

Pipeline

```
Developer

↓

CI

↓

Validate

↓

Security Scan

↓

Manual Approval

↓

Deploy
```

Never

```
Push

↓

Auto Deploy Production
```

without approvals.

---

# 25. Branch Protection

Protect

```
main
```

Enable

- Pull Requests
- Required Reviews
- Status Checks
- Linear History

---

# 26. Repository Protection

Enable

- Secret Scanning
- Dependabot
- Code Scanning
- Push Protection

---

# 27. Supply Chain Security

Use

- Dependabot
- CodeQL
- tfsec
- Trivy
- Renovate (optional)

Review third-party GitHub Actions regularly.

---

# 28. Dependency Security

Keep updated

- Terraform
- Providers
- GitHub Actions
- Python Packages

Review release notes before upgrades.

---

# 29. Monitoring

Monitor

- Lambda Errors
- Lambda Duration
- S3 Events
- DynamoDB Throttling
- Failed Deployments

---

# 30. Incident Response

If compromise suspected

Immediately

- Disable IAM Role
- Stop GitHub Workflows
- Rotate Secrets (if any)
- Review CloudTrail
- Review CloudWatch
- Review GitHub Audit Log

---

# 31. Security Checklist

## AWS

- [ ] OIDC Provider
- [ ] IAM Role
- [ ] Least Privilege
- [ ] Encrypted Backend
- [ ] Block Public Access

## GitHub

- [ ] Branch Protection
- [ ] OIDC
- [ ] Secrets Configured
- [ ] Variables Configured
- [ ] Environments Protected

## Terraform

- [ ] Remote State
- [ ] Validation
- [ ] Security Scan

## Lambda

- [ ] Dedicated Role
- [ ] Logging
- [ ] No Secrets

## S3

- [ ] Encryption
- [ ] Versioning
- [ ] Public Access Block

---

# 32. Common Security Mistakes

Avoid

- Root User for deployments
- AWS Access Keys in GitHub
- AdministratorAccess in production
- Public S3 buckets
- Local Terraform state
- Hardcoded passwords
- Hardcoded ARNs
- Ignoring tfsec findings
- Using latest GitHub Action tags
- No branch protection

---

# 33. Production Recommendations

Implement

- AWS Organizations
- SCPs
- IAM Identity Center
- KMS Customer Managed Keys
- Secrets Manager
- SSM Parameter Store
- CloudTrail Organization Trail
- AWS Config
- GuardDuty
- Security Hub
- Inspector
- AWS Backup

---

# 34. Security Maturity Model

### Level 1

- Manual IAM
- Local Terraform
- Access Keys

### Level 2

- GitHub Actions
- OIDC
- Remote Backend

### Level 3

- Reusable Workflows
- Modular Terraform
- Security Scanning
- Protected Environments

### Level 4

- Multi-Account AWS
- Automated Compliance
- Policy as Code
- Continuous Monitoring
- Enterprise Governance

---

# Summary

This project follows modern cloud security principles by using:

- GitHub OIDC instead of AWS access keys
- IAM Roles with temporary credentials
- Modular Terraform
- Remote encrypted Terraform state
- Reusable GitHub Actions workflows
- Least-privilege IAM policies
- Protected GitHub environments
- Security scanning in CI/CD

These practices provide a strong foundation for both learning and evolving the project into a production-grade platform.
