resource "aws_glue_job" "bartExtractGlueJob" {
  name     = "bartExtract-data-GA"
  role_arn = "${aws_iam_role.bartExtractGlueJobRole.arn}"
  glue_version =  "1.0"
  max_capacity = "1"

  command {
    script_location = "s3://${aws_s3_bucket.BartRecsS3BucketSources.bucket}/${aws_s3_bucket_object.BartRecsS3BucketSourcesExtractMainGlueJob.key}"
    python_version = 3
    name = "pythonshell"
  }

  default_arguments = {
    # config
    "--job-language" = "pythonshell"
    "--extra-py-files" = "s3://${aws_s3_bucket.BartRecsS3BucketSources.bucket}/${aws_s3_bucket_object.BartRecsS3BucketSourcesExtractEggGlueJob.key}"
  }

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}

resource "aws_glue_job" "bartJoinDataGlueJob" {
  name     = "bartJoin-data-GA"
  role_arn = "${aws_iam_role.bartExtractGlueJobRole.arn}"
  glue_version =  "1.0"
  max_capacity = "1"  

  command {
    script_location = "s3://${aws_s3_bucket.BartRecsS3BucketSources.bucket}/${aws_s3_bucket_object.BartRecsS3BucketSourcesJoinDataMainGlueJob.key}"
    python_version = 3
    name = "pythonshell"
  }

  default_arguments = {
    # config
    "--job-language" = "pythonshell"
    "--extra-py-files" = "s3://${aws_s3_bucket.BartRecsS3BucketSources.bucket}/${aws_s3_bucket_object.BartRecsS3BucketSourcesExtractEggGlueJob.key}"
  }

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}

resource "aws_glue_job" "bartCalcPublishGlueJob" {
  name     = "bart-calc-publish"
  role_arn = "${aws_iam_role.bartExtractGlueJobRole.arn}"
  glue_version =  "1.0"
  max_capacity = "1"

  command {
    script_location = "s3://${aws_s3_bucket.BartRecsS3BucketSources.bucket}/${aws_s3_bucket_object.BartRecsS3BucketSourcesCalcPublishMainGlueJob.key}"
    python_version = 3
    name = "glueetl"
  }

  default_arguments = {
    # config
    "--job-language" = "pythonshell"
    "--extra-py-files" = "s3://${aws_s3_bucket.BartRecsS3BucketSources.bucket}/${aws_s3_bucket_object.BartRecsS3BucketSourcesExtractEggGlueJob.key}"
  }

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}

resource "aws_glue_workflow" "bartExtractGlueInteractions" {
  name         = "bart-recs-interactions"
  description  = "Jobs para construção dos dados de interação com os produtos coletados do GA"
}

resource "aws_glue_trigger" "bartExtractGlueJob" {
  name     = "bartExtract-data-GA-everyday"
  schedule = "cron(30 20 * * ? *)"
  type     = "SCHEDULED"
  workflow_name = "${aws_glue_workflow.bartExtractGlueInteractions.name}"

  actions {
    job_name = "${aws_glue_job.bartExtractGlueJob.name}"
  }

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}

resource "aws_glue_trigger" "bartJoinDataGlueJob" {
  name          = "bartJoin-data-GA"
  type          = "CONDITIONAL"
  workflow_name = "${aws_glue_workflow.bartExtractGlueInteractions.name}"

  predicate {
    conditions {
      job_name = "${aws_glue_job.bartExtractGlueJob.name}"
      state    = "SUCCEEDED"
    }
  }

  actions {
    job_name = "${aws_glue_job.bartJoinDataGlueJob.name}"
  }

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}

resource "aws_glue_trigger" "bartCalcPublishGlueJob" {
  name          = "bart-calc-publish-wvav"
  type          = "CONDITIONAL"
  workflow_name = "${aws_glue_workflow.bartExtractGlueInteractions.name}"

  predicate {
    conditions {
      job_name = "${aws_glue_job.bartJoinDataGlueJob.name}"
      state    = "SUCCEEDED"
    }
  }

  actions {
    job_name = "${aws_glue_job.bartCalcPublishGlueJob.name}"
  }

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}
