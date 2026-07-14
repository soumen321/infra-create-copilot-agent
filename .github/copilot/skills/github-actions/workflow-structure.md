# Standard Workflow Architecture

Never create one large GitHub Actions workflow.

Use reusable workflows.

Standard Architecture

.github/workflows/

ci.yml

terraform-plan.yml

terraform-apply.yml

security-scan.yml

deploy.yml

---

Execution Flow

Push

↓

ci.yml

↓

terraform-plan.yml

↓

security-scan.yml

↓

terraform-apply.yml

↓

deploy.yml

---

Each workflow should perform one responsibility only.