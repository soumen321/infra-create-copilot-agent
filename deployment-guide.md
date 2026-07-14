Deployment

From repository root:

```bash
cd terraform/projects/demo-serverless
terraform init
terraform plan -var-file=../../environments/dev/terraform.tfvars
terraform apply -var-file=../../environments/dev/terraform.tfvars
```

Testing

1. Upload a `sample.txt` file into the S3 bucket.
2. Confirm a record appears in DynamoDB with `file_name`, `upload_time`, `content`.

Destroy

```bash
terraform destroy -var-file=../../environments/dev/terraform.tfvars
```
