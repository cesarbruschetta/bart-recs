""" module to methods to main  """
import boto3
import logging

from bartdatasets.extract.processor import extract_yesterday

logger = logging.getLogger(__name__)


def run():
    s3 = boto3.resource("s3")
    obj = s3.Object("source-bart-recs", "credentials/GA_credentials.json")

    return extract_yesterday(
        ga_viewId="ga:218694870",
        ga_credential=ga_credential.get()["Body"].read().decode("utf-8"),
        s3_path="s3://prd-lake-raw-bart",
    )


if __name__ == "__main__":
    run()
