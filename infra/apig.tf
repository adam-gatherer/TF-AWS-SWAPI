resource "aws_api_gateway_rest_api" "tf-swapi" {
    # Name & description
    name = "TF-SWAPI"
    description = "API Gateway to proxy requests to SWAPI"
    /*
    # Body specification for OpenAPI
    body = jsonencode({
        openapi = "3.0.1"
        info = {
            title =   "example"
            version = "1.0"
        }
        paths = {
            "/people" = {
                x-amazonapigateway-integration = {
                    httpMethod =           "GET"
                    payloadFormatVersion = "1.0"
                    type =                 "HTTP_PROXY"
                    uri =                  "https://API_HERE"
                }
            }
        }
    })
    */
    # Configuring the endpoint
    endpoint_configuration {
      # Setting the API to route requests to the nearest
      # CloudFront Point of Presence
      types = ["EDGE"]
    }
}

resource "aws_api_gateway_resource" "tf-swapi-resource" {
    parent_id = aws_api_gateway_rest_api.tf-swapi.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.tf-swapi.id
    path_part = "people"
}

resource "aws_api_gateway_method" "tf-swapi-method" {
    authorization = "NONE"
    http_method = "GET"
    resource_id = aws_api_gateway_resource.tf-swapi-resource.id
    rest_api_id = aws_api_gateway_rest_api.tf-swapi.id
}

resource "aws_api_gateway_integration" "tf-swapi-integration" {
    rest_api_id = aws_api_gateway_rest_api.tf-swapi.id
    resource_id = aws_api_gateway_resource.tf-swapi-resource.id
    http_method = "GET"
    type = "HTTP"
    uri = "https://swapi.dev/api/people"
}

/*
resource "aws_api_gateway_stage" "tf-swapi-stage" {
    deployment_id = aws_api_gateway_rest_api.tf-swapi.id
    rest_api_id = aws_api_gateway_rest_api.tf-swapi.id
    stage_name = ""
}
*/