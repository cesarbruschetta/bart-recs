import os
import json
import boto3


def lambda_handler(event, context):
    encoded_string = ''
    body = event.get('body')
    path = event.get('path')

    bucket_name = ""

    s3_path = os.path.join(
        event['path'], 
        f'{event['requestContext']['requestId']}.json'
    )
    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=body)

    message = "ok"
    return {
        "statusCode": 200,
        "headers": {},
        "body": json.dumps(message),
        "isBase64Encoded": False
    }