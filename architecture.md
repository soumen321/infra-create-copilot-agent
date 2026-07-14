Architecture

- S3 bucket receives text file uploads (.txt)
- S3 triggers Lambda via event notification
- Lambda downloads file, reads content, and stores `file_name`, `upload_time`, `content` into DynamoDB
