# Configure the AWS Provider

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = "bart-recs"
}
 
terraform {
  backend "s3" {
    bucket = "source-bart-recs"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
    profile = "bart-recs"
  }
}
