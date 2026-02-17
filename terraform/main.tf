terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  app_name = "tf-static-site"
  env      = "dev"
  tags = {
    Application = local.app_name
    Environment = local.env
    ManagedBy   = "terraform"
  }
}

terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket-euc1"
    key            = "static-site/dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf-locks-euc1"
    encrypt        = true
  }
}

# this is fake change
