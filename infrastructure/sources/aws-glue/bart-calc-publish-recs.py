import boto3
from awsglue.context import GlueContext
from pyspark.context import SparkContext

# Create Glue Context from Spark Context
glueContext = GlueContext(SparkContext.getOrCreate())
spark = glueContext.spark_session

from bartdatasets.recommendations.calculate_wvav import calculate
from bartdatasets.recommendations.publish_wvav import publish


def run():

    attributes = ["source_item_id"]
    min_occurrence = 2
    max_recommendations = 200
    dynamodb = boto3.resource("dynamodb")

    actions = spark.read.parquet("s3://prd-lake-raw-bart/interactions.parquet")
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
