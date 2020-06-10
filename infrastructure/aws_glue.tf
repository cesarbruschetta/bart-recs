resource "aws_glue_job" "bartExtractGlueJob" {
  name     = "bartExtract-data-GA"
  role_arn = "${aws_iam_role.bartExtractGlueJobRole.arn}"

  command {
    script_location = "s3://${aws_s3_bucket.BartRecsS3BucketSources.bucket}/${aws_s3_bucket_object.BartRecsS3BucketSourcesExtractMainGlueJob.key}"
    python_version = 3
    name = "pythonshell"
  }

  default_arguments = {
    "--ga-viewId" = "ga:218694870"
    "--ga-credential" = "${file("${var.ga_credential}")}"
    "--s3-path" = "s3://${aws_s3_bucket.BartRecsS3BucketLakeRaw.bucket}"
    # config
    "--job-language" = "pythonshell"
    "--extra-py-files" = "s3://${aws_s3_bucket.BartRecsS3BucketSources.bucket}/${aws_s3_bucket_object.BartRecsS3BucketSourcesExtractEggGlueJob.key}"
  }

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}

resource "aws_glue_trigger" "bartExtractGlueJob" {
  name     = "bartExtract-data-GA-everyday"
  schedule = "cron(30 20 * * ? *)"
  type     = "SCHEDULED"

  actions {
    job_name = "${aws_glue_job.bartExtractGlueJob.name}"
  }

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}

resource "aws_glue_catalog_database" "bartExtractGlueDataBase" {
  name         = "bart-recs-database"
  description  = "Base de dados para os dados coletados do GA"
  location_uri = "s3://prd-lake-raw-bart/database"
}

resource "aws_glue_crawler" "bartExtractGlueCrawler" {
  database_name = "${aws_glue_catalog_database.bartExtractGlueDataBase.name}"
  name          = "bart-recs-GA-interactions"
  description   = "Coleta os dados do GA e agrupa e salva na Tabela do Glue"
  role          = "${aws_iam_role.bartExtractGlueJobRole.arn}"

  schedule      = "cron(0 21 * * ? *)"

  s3_target {
    path = "s3://${aws_s3_bucket.BartRecsS3BucketLakeRaw.bucket}/ga_pageviews"
  }

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}