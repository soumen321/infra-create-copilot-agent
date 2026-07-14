IAM module

Creates an IAM role for Lambda execution and attaches a custom policy.

Inputs:

- `role_name` (string)
- `policy_name` (string)
- `policy_document` (any) - JSON policy document
- `tags` (map)

Outputs:

- `role_arn`
- `role_name`
