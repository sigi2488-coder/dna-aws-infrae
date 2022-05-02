resource "aws_apigatewayv2_api" "mutant_detector_api" {
  name          = "detector"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "mutant_detector_stage" {
  api_id = aws_apigatewayv2_api.mutant_detector_api.id

  name        = "detector-stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_log_group.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "mutant_detector_integration_dna_evaluator_lambda" {
  api_id = aws_apigatewayv2_api.mutant_detector_api.id

  integration_uri    = aws_lambda_function.dna_evaluator_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "mutant_detector_integration_dna_stats_lambda" {
  api_id = aws_apigatewayv2_api.mutant_detector_api.id

  integration_uri    = aws_lambda_function.dna_stats_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "dna_evaluator_api_route" {
  api_id = aws_apigatewayv2_api.mutant_detector_api.id

  route_key = "POST /mutant"
  target    = "integrations/${aws_apigatewayv2_integration.mutant_detector_integration_dna_evaluator_lambda.id}"
}

resource "aws_apigatewayv2_route" "dna_stats_api_route" {
  api_id = aws_apigatewayv2_api.mutant_detector_api.id

  route_key = "GET /stats"
  target    = "integrations/${aws_apigatewayv2_integration.mutant_detector_integration_dna_stats_lambda.id}"
}

resource "aws_cloudwatch_log_group" "api_gw_log_group" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.mutant_detector_api.name}"

  retention_in_days = 5
}

resource "aws_lambda_permission" "dna_evaluator_lambda_to_api_gw_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dna_evaluator_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.mutant_detector_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "dna_stats_lambda_to_api_gw_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dna_stats_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.mutant_detector_api.execution_arn}/*/*"
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.mutant_detector_stage.invoke_url
}