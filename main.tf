
terraform {
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~>4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2" {
  ami = "i-0d3e2c16fbc5d7154"
  instance_type = "t2.micro"
  tags={
    Name="App Server"
  }  
}