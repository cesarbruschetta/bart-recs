import boto3
import pandas as pd

from pyspark.sql import SparkSession

spark = (
    SparkSession.builder.master("local").appName("bart-calc-publish-recs").getOrCreate()
)

from bartdatasets.recommendations.calculate_wvav import calculate
from bartdatasets.recommendations.publish_wvav import publish


def run():

    attributes = ["source_item_id"]
    min_occurrence = 2
    max_recommendations = 200
    dynamodb = boto3.resource("dynamodb")

    actions = spark.createDataFrame(
        pd.read_parquet("s3://prd-lake-raw-bart/interactions.parquet")
    )
    recommendations = calculate(
        actions=actions,
        min_occurrence=min_occurrence,
        max_recommendations=max_recommendations,
        attributes=attributes,
    )

    publish(
        recommendations, dynamodb.Table("bart-recommendations-wvav"),
    )


if __name__ == "__main__":
    run()
