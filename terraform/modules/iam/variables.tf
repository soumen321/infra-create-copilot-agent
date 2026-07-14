variable "role_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "policy_document" {
  type = any
}

variable "tags" {
  type    = map(string)
  default = {}
}
