
provider "aws" {
  profile = "work" 
  region = "us-east-2"  
  version = "~> 2.3"
}

module "vpc1" {
  source = "./vpc"
  vpc_name = "AAVPC1"
  vpc_cidr = "10.1.0.0/16"
}

# module "ubuntu" {
#   source = "./ubuntu"
#   instance_name = "AAUBUNTU"
#   key_name = "AA"
#   subnet_id = module.vpc1.SUBNET10
#   security_group_id = module.vpc1.SSH_ICMP
# }

module "ubuntu-2eth" {
  source = "./ubuntu-2eth"
  instance_name = "AAUBUNTU"
  key_name = "AA"
  subnet_public_id = module.vpc1.SUBNET10
  subnet_private_id = module.vpc1.SUBNET11
  security_group_id = module.vpc1.SSH_ICMP
}
