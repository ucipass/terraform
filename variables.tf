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