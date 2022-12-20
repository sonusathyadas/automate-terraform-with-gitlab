
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
  ami = "ami-03d3eec31be6ef6f9"
  instance_type = "t2.micro"
  tags={
    Name="App Server"
  }  
}