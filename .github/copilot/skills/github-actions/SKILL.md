# GitHub Actions Skill

## Purpose

Generate, review, and optimize GitHub Actions workflows.

This repository follows an enterprise reusable workflow architecture.

---

## Architecture Rules

Always generate reusable workflows.

Never generate one large workflow unless the user explicitly requests it.

The default architecture is:

.github/
└── workflows/
    │
    ├── ci.yml                 # Entry point
    ├── terraform-plan.yml
    ├── terraform-apply.yml
    ├── security-scan.yml
    ├── build.yml
    └── deploy.yml

---

## Workflow Responsibilities

ci.yml

- Trigger workflow
- Call reusable workflows
- No business logic

terraform-plan.yml

- Checkout
- Setup Terraform
- Init
- Validate
- Plan
- Upload Plan

terraform-apply.yml

- Download Plan
- Approval
- Apply
- Output Summary

security-scan.yml

- Trivy
- Checkov
- tfsec
- Secret Scan

---

## Standards

Always

- workflow_call
- OIDC
- GitHub Secrets
- Least Privilege
- Pinned Action Versions

Never

- One large workflow
- Hardcoded credentials
- Duplicate YAML

Prefer reusable workflows over duplicated logic.