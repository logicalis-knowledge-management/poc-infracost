terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket = "logicalis-poc-infracost-tfstate"
    key    = "poc-infracost/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}

provider "aws" {
  region     = var.aws_region
}
