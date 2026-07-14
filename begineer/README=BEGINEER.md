# Beginner Guide: GitHub Copilot Agents + Skills + Instructions

> Learn how GitHub Copilot uses **Agents**, **Instructions**, and **Skills** to generate better Terraform code.

---

# Goal

In this tutorial, you will learn how to teach GitHub Copilot to generate infrastructure the way **you** want instead of relying on its default behavior.

At the end of this guide, you'll have a simple Terraform project that creates:

- Amazon S3 Bucket
- AWS Lambda Function

No GitHub Actions.

No OIDC.

No CI/CD.

Just understanding how Copilot works.

---

# What You'll Learn

- What is a Copilot Agent
- What are Instructions
- What is a Skill
- How Copilot reads them
- How to verify Copilot is using them
- Generate your first Terraform project

---

# Prerequisites

Install:

- Visual Studio Code
- Git
- Terraform
- AWS CLI
- GitHub Copilot Extension
- GitHub Copilot Chat Extension

Verify installation:

```bash
terraform version

aws --version

git --version
```

---

# Project Structure

Create the following folders.

```
.github/

└── copilot/

    ├── agents/

    │      infrastructure-agent.md

    │

    ├── instructions/

    │      coding.instructions.md

    │      terraform.instructions.md

    │

    └── skills/

           terraform/

                SKILL.md

                examples/

                    lambda-s3.tf

                templates/

                    module-template.tf
```

---

# Step 1 — Create an Agent

Create

```
.github/copilot/agents/infrastructure-agent.md
```

The Agent is the **brain** of your Copilot repository.

It decides:

- which Instructions to read
- which Skills to use
- how to answer the user

Think of it as a Team Lead assigning work to specialists.

```
User

↓

Infrastructure Agent

↓

Terraform Skill
```

---

# Step 2 — Create Instructions

Create

```
coding.instructions.md
```

and

```
terraform.instructions.md
```

Instructions define the coding standards.

Examples:

- Don't hardcode credentials
- Use variables
- Separate files
- Follow Terraform best practices

Think of Instructions as your company's engineering standards.

---

# Step 3 — Create a Skill

Create

```
skills/terraform/SKILL.md
```

A Skill teaches Copilot **how** to solve a specific problem.

Examples:

- Terraform
- Kubernetes
- Docker
- Python
- AWS
- GitHub Actions

One Skill should focus on one domain only.

---

# Step 4 — Add Examples

Create

```
examples/lambda-s3.tf
```

Example files show Copilot your preferred coding style.

Instead of guessing, Copilot learns from these examples.

Example:

```
resource "aws_s3_bucket" ...

resource "aws_lambda_function" ...
```

The more examples you provide, the more consistent Copilot becomes.

---

# Step 5 — Add Templates

Create

```
templates/module-template.tf
```

Templates provide reusable skeletons.

Instead of writing Terraform from scratch every time, Copilot starts from your template.

Templates improve consistency across projects.

---

# How Copilot Works

When you ask Copilot to generate infrastructure, it follows this process.

```
User Prompt

↓

Infrastructure Agent

↓

Read Instructions

↓

Read Skills

↓

Read Examples

↓

Read Templates

↓

Generate Code
```

This is why repository guidance produces better results than prompts alone.

---

# Your First Prompt

Open **GitHub Copilot Chat** in VS Code.

Select the **Infrastructure Engineering Agent**.

Ask:

```
Create a Terraform project that provisions

- one S3 bucket

- one Lambda function

Follow the Terraform Skill.

Follow all repository instructions.

Generate

providers.tf

variables.tf

outputs.tf

versions.tf

main.tf

README.md
```

---

# Expected Output

Copilot should generate something similar to:

```
terraform-demo/

├── README.md

├── providers.tf

├── versions.tf

├── variables.tf

├── outputs.tf

└── main.tf
```

---

# Verify Copilot is Using Your Repository

Ask Copilot:

```
Why did you generate providers.tf?
```

Expected answer:

Because the Terraform Skill requires provider configuration to be separated.

---

Ask:

```
Why did you create variables.tf?
```

Expected answer:

Because the Skill and Instructions recommend reusable Terraform code using variables.

---

Ask:

```
Why didn't you hardcode AWS credentials?
```

Expected answer:

Because the repository Instructions prohibit hardcoded credentials.

If Copilot answers using your repository guidance, then your Agent, Instructions, and Skill are working correctly.

---

# Test the Generated Terraform

Open a terminal.

Run:

```bash
terraform init
```

Then:

```bash
terraform fmt -recursive
```

Then:

```bash
terraform validate
```

Then:

```bash
terraform plan
```

If all commands succeed, your generated Terraform is valid.

---

# What You Have Learned

You now understand the basic GitHub Copilot workflow.

```
Prompt

↓

Agent

↓

Instructions

↓

Skill

↓

Examples

↓

Templates

↓

Generated Terraform
```

---

# Common Beginner Mistakes

Avoid:

- Putting all logic into one SKILL.md
- Creating one huge Agent for every technology
- Hardcoding AWS credentials
- Mixing examples and templates
- Skipping Instructions
- Expecting Copilot to know your standards without teaching it

---

# Best Practices

- Keep one Skill per technology.
- Keep Instructions short and clear.
- Add many examples.
- Use templates for reusable code.
- Make the Agent orchestrate Skills instead of containing implementation details.
- Test generated Terraform locally before deployment.

---

# What's Next?

Once you're comfortable with this basic setup, you can extend your repository with:

- GitHub Actions reusable workflows
- AWS OIDC authentication
- Modular Terraform architecture
- Security Skills
- Python Skills
- Docker Skills
- Kubernetes Skills
- Documentation generation
- Multi-Agent workflows

This beginner example is the foundation for building a production-ready GitHub Copilot engineering platform.
