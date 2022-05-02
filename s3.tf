resource "random_pet" "dna_bucket_sources_name" {
  prefix = "dna-bucket-sources"
  length = 4
}

output "dna_bucket_sources_name" {
  description = "Name of the S3 bucket used to store function code."
  value       = aws_s3_bucket.dna_bucket_sources.id
}

resource "aws_s3_bucket" "dna_bucket_sources" {
  bucket = random_pet.dna_bucket_sources_name.id

  /*acl           = "private"*/
  force_destroy = true
}


resource "aws_s3_object" "dna_evaluator_source" {
  bucket = aws_s3_bucket.dna_bucket_sources.id

  key    = "dna-evaluator-lambda.zip"
  source = "files/dna-evaluator-lambda.zip"

  etag = filemd5("files/dna-evaluator-lambda.zip")
}

resource "aws_s3_object" "dna_stats_source" {
  bucket = aws_s3_bucket.dna_bucket_sources.id

  key    = "dna-stats-lambda.zip"
  source = "files/dna-stats-lambda.zip"

  etag = filemd5("files/dna-stats-lambda.zip")
}