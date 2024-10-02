resource "aws_api_gateway_vpc_link" "mctechapi_vpc_link" {
  name        = "MCTech API VPC Link"
  target_arns = [data.aws_lb.mctech_nlb.arn]  # ARN do NLB

  # Use o ID da VPC
  description = "VPC Link to MCTech API NLB"
}


resource "aws_api_gateway_rest_api" "restapi" {
  name        = "MCTechApi"
  description = "API Gateway for MCTech API project"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  parent_id   = aws_api_gateway_rest_api.restapi.root_resource_id
  path_part   = "{proxy+}"  # Capture todas as rotas dinâmicas
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.restapi.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"  # Aceita qualquer método (GET, POST, etc.)
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.restapi.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_method.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.mctech_nlb.dns_name}:8080/api/{proxy}"  # Use o DNS do NLB aqui
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.mctechapi_vpc_link.id

  request_parameters =  {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  depends_on = [
    aws_api_gateway_method.proxy_method
  ]
}

resource "aws_api_gateway_deployment" "mctechapi_deployment" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  stage_name  = "preprod"

  depends_on = [
    aws_api_gateway_integration.proxy_integration
  ]
}

# Recurso para liberar acesso externo ao API Gateway criado
resource "aws_api_gateway_method_response" "response" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  status_code = "200"
}

# Saída com o endpoint do API Gateway
output "api_gateway_endpoint" {
  value = "${aws_api_gateway_deployment.mctechapi_deployment.invoke_url}/${aws_api_gateway_resource.proxy.path_part}"
}
