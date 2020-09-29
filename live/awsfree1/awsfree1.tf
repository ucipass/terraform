
provider "aws" {
  profile = "awsfree1" 
  region = "us-east-2"  
  version = "~> 2.3"
}

module "vpc1" {
  source = "./vpc"
  vpc_name = "VPC1"
  vpc_cidr = "172.28.0.0/16"
}

module "ubuntu-2eth" {
  source = "./ubuntu-2eth"
  HOST = "aws"
  DOMAIN = "arato.biz"
  DYNDNSPASS = var.DYNDNSPASS
  key_name = var.EC2_KEY
  subnet_public_id = module.vpc1.SUBNET10
  subnet_private_id = module.vpc1.SUBNET11
  security_group_id = module.vpc1.SSH_ICMP_WEB_IPERF
}

# module "ubuntu" {
#   source = "./ubuntu"
#   instance_name = "AAUBUNTU"
#   key_name = "AA"
#   subnet_id = module.vpc1.SUBNET10
#   security_group_id = module.vpc1.SSH_ICMP
# }

