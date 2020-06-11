import os

def lambda_handler(event, context):
    AUTHORIZED_CLIENTS = os.environ.get('AUTHORIZED_CLIENTS','')
    token = event['authorizationToken']

    is_allow = token in AUTHORIZED_CLIENTS.split(',')
    response = {
        "principalId": token,
        "policyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "execute-api:Invoke",
                    "Effect": is_allow and "Allow" or "Deny",
                    "Resource": event['methodArn']
                }
            ]
        },
    }
    if is_allow:
        return response
    else:
        raise Exception('403 Forbidden: %s' % (response))
