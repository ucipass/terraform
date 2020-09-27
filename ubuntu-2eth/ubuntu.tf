variable "instance_name" {
  type = string
}

variable "subnet_public_id" {
  type = string
}

variable "subnet_private_id" {
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


resource "aws_eip" "public_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.eth1.id
  # associate_with_private_ip = "10.1.1.10"
}

resource "aws_network_interface" "eth1" {
  subnet_id         = var.subnet_public_id
  # private_ips       = [ var.private_ip2 ]
  security_groups   = [ var.security_group_id ]
  source_dest_check = false
}

resource "aws_network_interface" "eth2" {
  subnet_id         = var.subnet_private_id
  # private_ips       = [ var.private_ip2 ]
  security_groups   = [ var.security_group_id ]
  source_dest_check = false
}

resource "aws_instance" "EC2_1" {
  tags = { Name = var.instance_name }
  ami  = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = var.key_name
  
  network_interface {
    network_interface_id = aws_network_interface.eth1.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.eth2.id
    device_index         = 1
  }


  # user_data = file("./script.sh")
  # provisioner "remote-exec" {
  #   inline = [ "cloud-init status --wait" ]
  # }

}

output "IP" {
  value = aws_instance.EC2_1.public_ip
}
