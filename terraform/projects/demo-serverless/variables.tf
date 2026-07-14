variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "demo-serverless"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "bucket_name" {
  type = string
}

variable "table_name" {
  type = string
}

variable "lambda_filename" {
  type    = string
  default = "../../../src/lambda-function.zip"
}

variable "tags" {
  type    = map(string)
  default = {}
}
