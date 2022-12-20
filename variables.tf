
variable "vpc_cidr_range" {
  type= string
  description = "CIDR range for VPC"
  default =  "10.5.0.0/16"
}

variable "subnet_cidr_range" {
  type= string
  description = "CIDR range for subnet"
  default = "10.5.1.0/24"
}

variable "s3_bucket_name" {
  type =string
  default = "sonu-tf-bucket"
  description = "S3 bucket name"
}

variable "server_count" {
  type = number
  default = 2
  description = "Specify the number of servers"
  validation {
    condition = var.server_count > 0
    error_message = "Server count value must be greater than zero."
  }
}

variable "server_image_id" {
  type = string 
  default = "ami-07ffb2f4d65357b42"
  description = "AMI ID for the server"
}

variable "server_instance_type" {
  type = string 
  default = "t2.micro"
  description = "Intance type for the EC2 server"
}

variable "ec2_username" {
  type =string
  default = "ubuntu"
  description = "EC2 server login username"
}