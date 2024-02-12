terraform {
    required_providers {
      aws = {
        version = "~> 4.9.0"
        source = "hashicorp/aws"
      }
    }
}

provider "aws" {
    region = "eu-west-1"
}

terraform {
    backend "s3" {
        bucket = "terrified-banana-tf-states"
        region = "eu-west-1"
        key = "tf-aws-swapi/state/main"
    }
}