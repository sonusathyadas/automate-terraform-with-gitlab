
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }

  backend "s3" {
    bucket = "tf-state-89430"
    key    = "terraform.state"
    region = "ap-south-1"
  }
}

provider "aws" {
  #   profile = "default"
  region = "ap-south-1"
  alias  = "aws-india"
}

provider "aws" {
  #   profile = "default"
  region = "us-east-1"
  alias  = "aws-us"
}


