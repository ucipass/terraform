variable "instance_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
  default = "AA"
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
  tags = { Name = var.instance_name }
  ami  = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id = var.subnet_id

  # user_data = file("./script.sh")
  # provisioner "remote-exec" {
  #   inline = [ "cloud-init status --wait" ]
  # }

}

output "IP" {
  value = aws_instance.EC2_1.public_ip
}
