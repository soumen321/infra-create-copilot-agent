variable "function_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "filename" {
  type = string
}

variable "environment_variables" {
  type = map(string)
}

variable "timeout" {
  type = number
}

variable "memory_size" {
  type = number
}

variable "tags" {
  type    = map(string)
  default = {}
}
