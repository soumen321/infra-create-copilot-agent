import boto3
from botocore.exceptions import ClientError
from logger import get_logger

logger = get_logger()
_s3 = boto3.client('s3')
_dynamodb = boto3.resource('dynamodb')


def download_s3_object(bucket, key):
    try:
        obj = _s3.get_object(Bucket=bucket, Key=key)
        body = obj['Body'].read()
        return body.decode('utf-8')
    except ClientError as e:
        logger.exception(f"Failed to download s3://{bucket}/{key}")
        raise


def put_item_dynamodb(table_name, item):
    table = _dynamodb.Table(table_name)
    try:
        table.put_item(Item=item)
    except ClientError:
        logger.exception(f"Failed to write item to DynamoDB table {table_name}")
        raise
