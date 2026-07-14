# Reusable Workflow Standard

This organization uses reusable GitHub Actions workflows.

## Architecture

.github/workflows/

ci.yml

terraform-plan.yml

terraform-apply.yml

security-scan.yml

deploy.yml

---

## ci.yml

Responsibilities

- Trigger on push
- Trigger on pull request
- Call reusable workflows

Do not perform deployment logic.

---

## terraform-plan.yml

Called by workflow_call.

Responsibilities

Checkout

Setup Terraform

terraform fmt

terraform init

terraform validate

terraform plan

Upload Plan

---

## terraform-apply.yml

Called by workflow_call.

Responsibilities

Download Plan

Manual Approval

terraform apply

---

## security-scan.yml

Run

Trivy

Checkov

tfsec

Secret Scan

---

## deploy.yml

Deploy Infrastructure

Smoke Test

Notify

---

## Rules

Every workflow must have one responsibility.

Never duplicate Terraform commands.

Always use workflow_call.