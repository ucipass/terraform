variable "vpc_name" {
  type = string
  default = "AA1"
}

variable "vpc_cidr" {
  type = string
  default = "10.1.0.0/16"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "AAVPC" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_default_route_table" "RT_DEFAULT" {
  default_route_table_id = aws_vpc.AAVPC.default_route_table_id

  tags = {
    Name = format("%s_%s",var.vpc_name,"RT_DEFAULT")
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.AAVPC.id

  tags = {
    Name = format("%s_%s",var.vpc_name,"IGW")
  }
}

resource "aws_route_table" "RT_PUBLIC" {
  vpc_id = aws_vpc.AAVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = format("%s_%s",var.vpc_name,"RT_PUBLIC")
  }
}

resource "aws_route_table" "RT_PRIVATE" {
  vpc_id = aws_vpc.AAVPC.id

  tags = {
    Name = format("%s_%s",var.vpc_name,"RT_PRIVATE")
  }
}

resource "aws_subnet" "SUBNET10" {
  vpc_id     = aws_vpc.AAVPC.id
  cidr_block = format("%s%s", trimsuffix(var.vpc_cidr,"0.0/16") ,"10.0/24")
  availability_zone= data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s_%s",var.vpc_name,"SUBNET10")
  }
}

resource "aws_route_table_association" "RT_ASSOC_VPC_SUBNET10" {
  subnet_id = aws_subnet.SUBNET10.id
  route_table_id = aws_route_table.RT_PUBLIC.id
}

resource "aws_subnet" "SUBNET20" {
  vpc_id     = aws_vpc.AAVPC.id
  cidr_block = format("%s%s", trimsuffix(var.vpc_cidr,"0.0/16") ,"20.0/24")
  availability_zone= data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s_%s",var.vpc_name,"SUBNET20")
  }
}

resource "aws_route_table_association" "RT_ASSOC_VPC_SUBNET20" {
  subnet_id = aws_subnet.SUBNET20.id
  route_table_id = aws_route_table.RT_PUBLIC.id
}

resource "aws_subnet" "SUBNET11" {
  vpc_id     = aws_vpc.AAVPC.id
  cidr_block = format("%s%s", trimsuffix(var.vpc_cidr,"0.0/16") ,"11.0/24")
  availability_zone= data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = format("%s_%s",var.vpc_name,"SUBNET11")
  }
}

resource "aws_route_table_association" "RT_ASSOC_VPC_SUBNET11" {
  subnet_id = aws_subnet.SUBNET11.id
  route_table_id = aws_route_table.RT_PRIVATE.id
}

resource "aws_subnet" "SUBNET12" {
  vpc_id     = aws_vpc.AAVPC.id
  cidr_block = format("%s%s", trimsuffix(var.vpc_cidr,"0.0/16") ,"12.0/24")
  availability_zone= data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = format("%s_%s",var.vpc_name,"SUBNET12")
  }
}

resource "aws_route_table_association" "RT_ASSOC_VPC_SUBNET12" {
  subnet_id = aws_subnet.SUBNET12.id
  route_table_id = aws_route_table.RT_PRIVATE.id
}

resource "aws_subnet" "SUBNET21" {
  vpc_id     = aws_vpc.AAVPC.id
  cidr_block = format("%s%s", trimsuffix(var.vpc_cidr,"0.0/16") ,"21.0/24")
  availability_zone= data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = format("%s_%s",var.vpc_name,"SUBNET21")
  }
}

resource "aws_route_table_association" "RT_ASSOC_VPC_SUBNET21" {
  subnet_id = aws_subnet.SUBNET21.id
  route_table_id = aws_route_table.RT_PRIVATE.id
}

resource "aws_subnet" "SUBNET22" {
  vpc_id     = aws_vpc.AAVPC.id
  cidr_block = format("%s%s", trimsuffix(var.vpc_cidr,"0.0/16") ,"22.0/24")
  availability_zone= data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = format("%s_%s",var.vpc_name,"SUBNET22")
  }
}

resource "aws_route_table_association" "RT_ASSOC_VPC_SUBNET22" {
  subnet_id = aws_subnet.SUBNET22.id
  route_table_id = aws_route_table.RT_PRIVATE.id
}

resource "aws_security_group" "SSH_ICMP" {
  name        = "allow_ssh"
  description = "Allow ssh traffic"
  vpc_id      = aws_vpc.AAVPC.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s_%s",var.vpc_name,"SSH_ICMP")
  }

}

resource "aws_security_group" "SSH_ICMP_WEB_IPERF" {
  name        = "allow_ssh_icmp_web_iperf"
  description = "Allow ssh traffic"
  vpc_id      = aws_vpc.AAVPC.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow IPERF"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow IPERF3"
    from_port   = 5201
    to_port     = 5201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow IPERF_UDP"
    from_port   = 5001
    to_port     = 5001
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow IPERF3_UDP"
    from_port   = 5201
    to_port     = 5201
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s_%s",var.vpc_name,"SSH_ICMP")
  }

}


output "SSH_ICMP" {
  value = aws_security_group.SSH_ICMP.id
}
output "SSH_ICMP_WEB_IPERF" {
  value = aws_security_group.SSH_ICMP_WEB_IPERF.id
}
output "SUBNET10" {
  value = aws_subnet.SUBNET10.id
}
output "SUBNET11" {
  value = aws_subnet.SUBNET11.id
}
output "SUBNET12" {
  value = aws_subnet.SUBNET12.id
}
output "SUBNET20" {
  value = aws_subnet.SUBNET20.id
}
output "SUBNET21" {
  value = aws_subnet.SUBNET21.id
}
output "SUBNET22" {
  value = aws_subnet.SUBNET22.id
}
