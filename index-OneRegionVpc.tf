
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
