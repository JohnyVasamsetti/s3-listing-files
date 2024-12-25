resource "aws_s3_bucket" "this" {
  bucket = "s3-listing-task-statefiles"

  tags = {
    task  = "s3-listing"
  }
}
