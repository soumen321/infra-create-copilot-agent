
resource "aws_kms_key" "dynamodb" {
  description             = "DynamoDB encryption key"
  deletion_window_in_days = 7
  enable_key_rotation = true
}

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamodb.arn
  }

  point_in_time_recovery {
    enabled = true
  }
  tags = var.tags
}



