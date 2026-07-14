# Terraform Skill

## Purpose

This skill generates, reviews, and explains Terraform infrastructure.

Always follow repository instructions before generating code.

---

## Responsibilities

Generate Terraform

Review Terraform

Explain Terraform

Refactor Terraform

Optimize Terraform

---

## Use These References

project-structure.md

modules.md

backend.md

naming.md

tagging.md

security.md

validation.md

---

## Repository Layout

All generated Terraform must follow the enterprise repository structure.

Projects/

Contains deployable business applications.

Modules/

Contains reusable infrastructure modules.

Environments/

Contains backend configuration and tfvars.

Shared/

Contains organization-wide locals and tags.

Never generate flat Terraform repositories.

Always generate modular infrastructure.

---

## Output

Always produce

providers.tf

versions.tf

variables.tf

outputs.tf

main.tf

README.md

Never place everything inside one file.

---

## Standards

Use reusable modules.

Use variables.

Never hardcode values.

Always tag resources.

Always validate inputs.

Always explain generated resources.
