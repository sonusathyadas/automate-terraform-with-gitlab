
locals {
  tags = {
    Name = "Terraform-VPC-${terraform.workspace}"
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}


resource "aws_vpc" "my-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = local.tags
}

resource "aws_subnet" "my-subnet" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.azs.names,0)
  tags = {
    Name = "${local.tags.Name}-Subnet"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    "Name" = "${local.tags.Name}-IGW"
  }
}

resource "aws_default_route_table" "my-vpc-rt" {
  default_route_table_id = aws_vpc.my-vpc.main_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    "Name" = "${local.tags.Name}-RT"
  }
}

resource "aws_default_security_group" "my-vpc-sg" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "${local.tags.Name}-SG"
  }
  ingress {
    protocol    = -1
    self        = true
    from_port   = 0
    to_port     = 0
    description = "Default rule"
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3389
    to_port     = 3389
    description = "Allow RDP"
  }
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    description = "Allow SSH"
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    description = "Allow Http"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}