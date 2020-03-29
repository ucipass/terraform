
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

module "ubuntu1" {
  source = "./ubuntu"
  instance_name = "AAVPC1-UB1"
  subnet_id = "${module.vpc1.SUBNET10}"
  security_group_id = module.vpc1.SSH_ICMP
}

module "csr1kv" {
  source = "./csr1kv"
  instance_name = "CSR1KV-1"
  subnet_id1 = "${module.vpc1.SUBNET10}"
  private_ip1 = "10.1.10.251"
  subnet_id2 = "${module.vpc1.SUBNET11}"
  private_ip2 = "10.1.11.251"
  security_group_id = module.vpc1.SSH_ICMP
}

####################################################
# In case we need resources in another region
####################################################

# provider "aws" {
#   profile = "work" 
#   region = "us-east-2"  
#   version = "~> 2.3"
#   alias  = "usw1"
# }

# module "vpc2" {
#   source = "./vpc"
#   providers = { aws = "aws.usw1" }
#   vpc_name = "AAVPC2"
#   vpc_cidr = "10.2.0.0/16"
# }
