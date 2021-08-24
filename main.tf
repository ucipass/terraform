provider "aws" {
  region = var.AWS_REGION
}

# module "vpc1" {
#   source = "./modules/vpc"
#   vpc_name = var.VPC_NAME
#   vpc_cidr = var.VPC_CIDR
# }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.VPC_NAME
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "custom_sg" {
  depends_on = [module.vpc]
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.NAME}_SG"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = ["10.0.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = -1
      description = "User-service ports"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = var.NAME
  instance_count         = 1

  ami                    = "ami-0279406e0655775be" 
  instance_type          = "t2.micro"
  key_name               = "AA"
  monitoring             = true
  vpc_security_group_ids = [module.custom_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  count=2
  zone_name = "aws.cooltest.site"

  records = [
    {
      name    = "${var.NAME}-${count.index}"
      type    = "A"
      ttl     = 3600
      records = [
        module.ec2_cluster.public_ip[count.index],
      ]
    },
  ]
}