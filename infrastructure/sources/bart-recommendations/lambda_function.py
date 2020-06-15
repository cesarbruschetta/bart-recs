import os
import json
import boto3


def lambda_handler(event, context):

    message = "ok"
    return {
        "statusCode": 200,
        "headers": {},
        "body": json.dumps(message),
        "isBase64Encoded": False,
    }
