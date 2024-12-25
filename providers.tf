provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket  = "s3-listing-task-statefiles"
    region  = "us-east-1"
    profile = "beach"
    key     = "s3-listing-assignment"
  }
  required_version = ">= 1.3.3"
}
