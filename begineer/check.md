resource "aws_s3_bucket" "demo" {
bucket = var.bucket_name
}

resource "aws_lambda_function" "demo" {

function_name = var.lambda_name

role = aws_iam_role.lambda.arn

runtime = "python3.12"

handler = "index.handler"

filename = "lambda.zip"
}

This teaches Copilot your preferred style.

6. Template
   templates/module-template.tf
   resource "<RESOURCE_TYPE>" "<NAME>" {

}

Templates make Copilot more consistent.

Beginner Prompt

Now open Copilot Chat inside VS Code.

Choose

Infrastructure Engineering Agent

Then ask

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
What Copilot Does Internally
Prompt

↓

Infrastructure Agent

↓

Reads coding.instructions.md

↓

Reads terraform.instructions.md

↓

Reads Terraform Skill

↓

Reads Example

↓

Reads Template

↓

Generates Terraform
How to Verify the Agent is Working

Ask Copilot:

Why did you create providers.tf?

If it answers based on your Terraform Skill ("because the skill requires separate provider configuration"), the agent is following the repository guidance.

Next ask:

Why didn't you hardcode AWS credentials?

It should reference your instructions.

Then ask:

Why did you generate variables.tf?

It should explain that the Terraform Skill requires variables to be separated.

These responses confirm that Copilot is using your repository context instead of only its built-in knowledge.

Expected Generated Project
terraform-demo/

├── README.md
├── providers.tf
├── versions.tf
├── variables.tf
├── outputs.tf
└── main.tf
Learning Flow
Step 1
Create Agent

        ↓

Step 2
Create Instructions

        ↓

Step 3
Create Skill

        ↓

Step 4
Add Example

        ↓

Step 5
Add Template

        ↓

Step 6
Open Copilot Chat

        ↓

Step 7
Select Infrastructure Agent

        ↓

Step 8
Give Prompt

        ↓

Step 9
Review Generated Files

        ↓

Step 10
Run Terraform Locally
After Copilot Generates the Code

Run these commands:

cd terraform-demo

terraform init

terraform fmt -recursive

terraform validate

terraform plan

If all commands succeed, you've verified the complete Agent → Instructions → Skill → Example → Template → Terraform workflow.

This is the simplest end-to-end example for understanding how GitHub Copilot custom agents work before adding reusable GitHub Actions, OIDC, CI/CD, and more advanced enterprise patterns.
