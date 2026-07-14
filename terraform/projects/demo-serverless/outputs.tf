output "bucket_id" { value = module.s3.bucket_id }
output "table_name" { value = module.dynamodb.table_name }
output "lambda_function_name" { value = module.lambda.function_name }
