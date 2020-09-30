
provider "aws" {
  profile = "work" 
  region = "us-east-2"  
  version = "~> 2.3"
}

provider "aws" {
  profile = "work" 
  region = "us-west-1"  
  version = "~> 2.3"
  alias  = "usw1"
}

module "vpc2" {
  source = "./vpc"
  providers = { aws = "aws.usw1" }
  vpc_name = "AAVPC2"
  vpc_cidr = "10.2.0.0/16"
}

module "vpc1" {
  source = "./vpc"
  vpc_name = "AAVPC1"
  vpc_cidr = "10.1.0.0/16"
}
