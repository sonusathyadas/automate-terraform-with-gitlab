
module "network_mod" {
  source = "./modules/network"
  vpc_cidr = var.vpc_cidr_range
  subnet_cidr = var.subnet_cidr_range
  providers = {
    aws = aws.aws-india 
   }
}

module "storage_mod" {
  source = "./modules/storage"
  bucket_name = var.s3_bucket_name
  providers = {
    aws = aws.aws-us 
   }
}

module "compute_mod" {
  source = "./modules/compute"
  server_count = var.server_count
  image_id = var.server_image_id
  instance_type = var.server_instance_type
  subnet_id = module.network_mod.subnet_id
  username = var.ec2_username
  private_key = file("LinuxKey.pem")
  providers = {
    aws = aws.aws-india 
   }
}