output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_full" {
  value = module.vpc
}

output "ami_id_ubuntu" {
  value = data.aws_ami.ubuntu
}