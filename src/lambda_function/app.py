from datetime import datetime
import os
from logger import get_logger
from config import get_table_name
from helpers import download_s3_object, put_item_dynamodb

logger = get_logger()
TABLE = get_table_name()

def process_record(record):
    bucket = record['s3']['bucket']['name']
    key = record['s3']['object']['key']
    logger.info(f"Processing s3://{bucket}/{key}")

    content = download_s3_object(bucket, key)
    upload_time = datetime.utcnow().isoformat()

    item = {
        'file_name': key,
        'upload_time': upload_time,
        'content': content
    }

    put_item_dynamodb(TABLE, item)
    logger.info(f"Stored metadata for {key}")


def handler(event, context):
    logger.info(f"Received event: {event}")
    try:
        for record in event.get('Records', []):
            process_record(record)
    except Exception as e:
        logger.exception("Error processing event")
        raise
    return {'statusCode': 200}
