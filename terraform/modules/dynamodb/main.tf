#tfsec:ignore:aws-dynamodb-table-customer-key
#tfsec:ignore:aws-dynamodb-enable-ttl
resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }
  tags = var.tags
}



