module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
  tags        = local.common_tags
}

module "dynamodb" {
  source     = "../../modules/dynamodb"
  table_name = var.table_name
  hash_key   = "file_name"
  tags       = local.common_tags
}

module "iam" {
  source      = "../../modules/iam"
  role_name   = "${var.project_name}-${var.environment}-lambda-role"
  policy_name = "${var.project_name}-${var.environment}-lambda-policy"

  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem"
        ],
        Resource = "${module.dynamodb.table_arn}"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = "${module.s3.bucket_arn}/*"
      }
    ]
  })

  tags = local.common_tags
}

module "lambda" {
  source        = "../../modules/lambda"
  function_name = "${var.project_name}-${var.environment}-processor"
  role_arn      = module.iam.role_arn
  filename      = var.lambda_filename
  handler       = "app.handler"
  runtime       = "python3.12"
  timeout       = 30
  memory_size   = 256
  environment_variables = {
    TABLE_NAME  = var.table_name
    BUCKET_NAME = var.bucket_name
  }
  tags = local.common_tags
}

# Grant S3 permission to invoke the Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3.bucket_arn
}

# Configure S3 to notify Lambda for .txt object creates
resource "aws_s3_bucket_notification" "notify_lambda" {
  bucket = module.s3.bucket_id

  lambda_function {
    lambda_function_arn = module.lambda.function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".txt"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
