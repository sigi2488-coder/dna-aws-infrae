resource "aws_lambda_function" "dna_evaluator_lambda" {
  function_name = "dna-evaluator"

  s3_bucket = aws_s3_bucket.dna_bucket_sources.id
  s3_key    = aws_s3_object.dna_evaluator_source.key

  runtime = "nodejs12.x"
  handler = "src/index.handler"

  source_code_hash = aws_s3_object.dna_evaluator_source.etag
  role             = aws_iam_role.lambda_exec_role.arn
}

resource "aws_lambda_function" "dna_stats_lambda" {
  function_name = "dna-stats"

  s3_bucket = aws_s3_bucket.dna_bucket_sources.id
  s3_key    = aws_s3_object.dna_stats_source.key

  runtime = "nodejs12.x"
  handler = "src/index.handler"

  source_code_hash = aws_s3_object.dna_stats_source.etag
  role             = aws_iam_role.lambda_exec_role.arn
}

resource "aws_cloudwatch_log_group" "dna_evaluator_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.dna_evaluator_lambda.function_name}"
  retention_in_days = 5
}

resource "aws_cloudwatch_log_group" "dna_stats_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.dna_stats_lambda.function_name}"
  retention_in_days = 5
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "function_name_dna_evaluator" {
  description = "Name of the Lambda evaluator."
  value       = aws_lambda_function.dna_evaluator_lambda.function_name
}
output "function_name_dna_stats" {
  description = "Name of the Lambda stats."
  value       = aws_lambda_function.dna_stats_lambda.function_name
}