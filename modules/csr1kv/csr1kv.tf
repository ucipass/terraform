variable "instance_name" {
  type = string
}

variable "subnet_id1" {
  type = string
}

variable "private_ip1" {
  type = string
}

variable "subnet_id2" {
  type = string
}

variable "private_ip2" {
  type = string
}

variable "security_group_id" {
  type = string
}

data "aws_ami" "csr1kv" {
  most_recent = true
  owners = ["aws-marketplace"] 

  filter {
    name = "name"
    values = ["CSR_AMI-cppbuild.17.1.1-byol*"]
  }
  filter {
    name = "product-code"
    values = ["5tiyrfb5tasxk9gmnab39b843"]
  }
}

resource "aws_eip" "public_ip" {
  vpc                       = true
  network_interface         = "${aws_network_interface.csr1kv_int1.id}"
  # associate_with_private_ip = "10.1.1.10"
}

resource "aws_network_interface" "csr1kv_int1" {
  subnet_id         = var.subnet_id1
  private_ips       = [ var.private_ip1 ]
  security_groups   = [ var.security_group_id ]
  source_dest_check = false
  
  tags = {
    Name = "csr1kv_int1"
  }
}

resource "aws_network_interface" "csr1kv_int2" {
  subnet_id         = var.subnet_id2
  private_ips       = [ var.private_ip2 ]
  security_groups   = [ var.security_group_id ]
  source_dest_check = false

  tags = {
    Name = "csr1kv_int2"
  }
}

resource "aws_instance" "EC2_1" {
  #ssh -i mykeypair.pem ec2-user@myhostname.compute-1.amazonaws.com
  ami           = "${data.aws_ami.csr1kv.id}"
  instance_type = "c5.large" # or c5.xlarge for 8GB
  key_name = "AA-TEST"

  network_interface {
    network_interface_id = aws_network_interface.csr1kv_int1.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.csr1kv_int2.id
    device_index         = 1
  }

  user_data = file("./csr1kv/csr1kv_config.txt")
  tags = {
    Name = var.instance_name
  }

}

output "IP" {
  value = "${aws_instance.EC2_1.public_ip}"
}
