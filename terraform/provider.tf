terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0"
    }
  }
  backend "s3" {
    bucket = "my-mega-bucket-gs"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-south-1"
}