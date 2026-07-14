### Use Case 1 — Static Website Hosting (Beginner)

Use the Infrastructure Engineering Agent.

Create a production-ready Terraform project named static-website.

Requirements

- AWS
- S3
- CloudFront
- ACM Certificate
- Route53

Follow the Terraform Skill.

Follow the AWS Skill.

Use modular Terraform architecture.

Create separate modules for

- s3
- cloudfront
- acm
- route53

Generate

- README.md
- Architecture Diagram
- Deployment Guide

Explain how users access the website through CloudFront.



### Use Case 2 — Scheduled Lambda (CloudWatch Scheduler)

Use the Infrastructure Engineering Agent.

Create a production-ready Terraform project named scheduled-lambda.

Requirements

- AWS
- Lambda
- EventBridge Scheduler
- IAM
- CloudWatch Logs

Follow the Terraform Skill.

Follow the AWS Skill.

Use modular Terraform architecture.

Create separate modules for

- lambda
- iam
- eventbridge

Generate a sample Python Lambda that logs the current timestamp.

Generate

- README.md
- Architecture Diagram
- Testing Guide

Explain how EventBridge triggers Lambda every 5 minutes.

### Use Case 3 — S3 Image Processing Pipeline

Use the Infrastructure Engineering Agent.

Create a production-ready Terraform project named image-processor.

Requirements

- AWS
- S3
- Lambda
- DynamoDB

Follow the Terraform Skill.

Follow the AWS Skill.

Use modular Terraform architecture.

Create separate modules for

- s3
- lambda
- dynamodb
- iam

Generate a Python Lambda that

- receives an S3 ObjectCreated event
- extracts image metadata
- stores metadata in DynamoDB

Generate

- README.md
- Architecture Diagram
- Sample Event JSON
- Testing Guide

Explain the complete event flow.

### Use Case 4 — Secure Terraform with Reusable GitHub Actions

Use the Infrastructure Engineering Agent.

Create a production-ready Terraform project named secure-infra.

Requirements

- AWS
- Lambda
- S3
- DynamoDB

Follow the Terraform Skill.

Follow the GitHub Actions Skill.

Follow the Security Skill.

Generate reusable GitHub Actions workflows for

- CI
- Terraform Plan
- Terraform Apply
- Terraform Destroy
- Security Scan

Use GitHub OIDC authentication.

Do not use AWS access keys.

Generate

- README.md
- AWS_SETUP.md
- GITHUB_ACTIONS_GUIDE.md
- SECURITY_BEST_PRACTICES.md

Explain how reusable workflows are connected.

### Use Case 5 — REST API with API Gateway + Lambda + DynamoDB

Use the Infrastructure Engineering Agent.

Create a production-ready Terraform project named serverless-api.

Requirements

- AWS
- API Gateway
- Lambda
- DynamoDB
- IAM

Follow the Terraform Skill.

Follow the AWS Skill.

Use modular Terraform architecture.

Create separate modules for

- api-gateway
- lambda
- dynamodb
- iam

Generate a Python Lambda that

- accepts HTTP requests
- stores JSON data in DynamoDB
- returns a success response

Generate

- README.md
- API Documentation
- Architecture Diagram
- Testing Guide
- Sample curl commands

Explain the request flow from API Gateway to DynamoDB.
