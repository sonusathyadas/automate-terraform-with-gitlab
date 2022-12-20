
variable "server_count" {
  type = number
  default = 1
  description = "Specify the number of servers"
  validation {
    condition = var.server_count > 0
    error_message = "Server count value must be greater than zero."
  }
}

variable "image_id" {
  type = string 
  default = "ami-07ffb2f4d65357b42"
  description = "AMI ID for the server"
}

variable "instance_type" {
  type = string 
  default = "t2.micro"
  description = "Intance type for the EC2 server"
}

variable "subnet_id" {
  type =string
  description = "Subnet ID where the EC2 server need to be created."
}

variable "username" {
  type =string
  description = "EC2 server login username"
}

variable "private_key" {
  
}