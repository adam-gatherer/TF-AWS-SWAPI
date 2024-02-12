# Creating the gateway for the REST API
resource "aws_api_gateway_rest_api" "tf-swapi" {
    # Name & description
    name = "TF-SWAPI"
    description = "API Gateway to proxy requests to SWAPI"
    /*
    # Body specification for OpenAPI - we're not doing this!
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

# Creating the resource, this is the endpoint to which users send requests
resource "aws_api_gateway_resource" "tf-swapi-resource" {
    parent_id = aws_api_gateway_rest_api.tf-swapi.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.tf-swapi.id
    path_part = "people"
}

# the method users can use against our API
resource "aws_api_gateway_method" "tf-swapi-method" {
    authorization = "NONE"
    http_method = "GET"
    # ID of the resource
    resource_id = aws_api_gateway_resource.tf-swapi-resource.id
    # ID of our REST API
    rest_api_id = aws_api_gateway_rest_api.tf-swapi.id
}

# The gateway integration is where the API requests are sent
resource "aws_api_gateway_integration" "tf-swapi-integration" {
    # ID of our REST API
    rest_api_id = aws_api_gateway_rest_api.tf-swapi.id
    # ID of the resource
    resource_id = aws_api_gateway_resource.tf-swapi-resource.id
    # The HTTP method used 
    http_method = aws_api_gateway_method.tf-swapi-method.http_method
    # the type of integration we're using
    type = "HTTP"
    # URI to which the requests are sent
    uri = "https://swapi.dev/api/people"
    # the type of method used when sending the request
    integration_http_method = "GET"
    # makes sure tf won't start deploying this resource until the
    # specified resource has already been deployed
    depends_on = [ aws_api_gateway_method.tf-swapi-method ]
}

# we'll get to this later
/*
resource "aws_api_gateway_stage" "tf-swapi-stage" {
    deployment_id = aws_api_gateway_rest_api.tf-swapi.id
    rest_api_id = aws_api_gateway_rest_api.tf-swapi.id
    stage_name = ""
}
*/