terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">=5.0"
    }
    random = {
        source = "hashicorp/random"
        version = ">=3.5"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  #profile = "tf-admin"
}

resource "random_id" "suffix" {
  byte_length = 2
}