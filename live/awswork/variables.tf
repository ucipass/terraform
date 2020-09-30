variable "AWS_PROFILE" {
  default="work"
  type = string
}

variable "AWS_REGION" {
  default="us-east-2"
  type = string
}

variable "VPC_NAME" {
  default="VPC1"
  type = string
}

variable "VPC_CIDR" {
  default="172.18.0.0/16"
  type = string
}

variable "HOST" {
  default="awshost1"
  type = string
}

variable "DOMAIN" {
  default="cooltest.site"
  type = string
}

variable "DYNDNSPASS" {
  type = string
}

variable "EC2_KEY" {
  default="AA"
  type = string
}

