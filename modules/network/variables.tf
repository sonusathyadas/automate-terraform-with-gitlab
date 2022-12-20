
variable "vpc_cidr" {
  type= string
  description = "CIDR range for VPC"
  default =  "10.5.0.0/16"
}

variable "subnet_cidr" {
  type= string
  description = "CIDR range for subnet"
  default = "10.5.1.0/24"
}