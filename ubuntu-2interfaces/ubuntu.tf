provider "aws" {
  profile = "work" 
  region = "us-east-2"  
  version = "~> 2.3"
}

variable "instance_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu*18.04*amd64*server*"]
  }
}

resource "aws_instance" "EC2_1" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  # vpc_security_group_ids = ["${aws_security_group.allow_ssh_icmp.id}"]
  # subnet_id="${aws_subnet.AAVPC_SUBNET1.id}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  subnet_id="${var.subnet_id}"
  key_name = "AA-TEST"
  
  tags = {
    Name = var.instance_name
  }

  # user_data = "${file("./script.sh")}"
  # provisioner "remote-exec" {
  #   inline = [ "cloud-init status --wait" ]
  # }

}

output "IP" {
  value = "${aws_instance.EC2_1.public_ip}"
}
