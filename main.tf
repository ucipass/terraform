provider "aws" {
  region = var.AWS_REGION
}

module "vpc1" {
  source = "./modules/vpc"
  vpc_name = var.VPC_NAME
  vpc_cidr = var.VPC_CIDR
}