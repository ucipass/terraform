variable "VM_NAME" {
  description = "Ubuntu virtual machine name"
  default = "AA_UB1"
  type = string
}

variable "VM_ADMIN_USERNAME" {
  description = "admin username for virtual machine"
  type = string
}

variable "VM_ADMIN_SSH_KEY" {
  description = "ssh key for admin user"
  type = string
}

variable "SUBNET1_ADDRESS_SPACE" {
  default = "10.1.1.0/24"
  type = string
}

variable "SUBNET1_NAME" {
  default = "AA_RG_SUBNET1"
  type = string
}

variable "VNET_ADDRESS_SPACE" {
  default = "10.1.0.0/16"
  type = string
}

variable "VNET_NAME" {
  default = "AA_RG_VNET"
  type = string
}

variable "RG_NAME" {
  default = "AA_RG"
  type = string
}

variable "RG_LOCATION" {
  default = "Central US"
  description = "The Azure region where the resources will be built"
  type = string
}

variable "SUBSCRIPTION_ID" {
  type = string
}

variable "TENANT_ID" {
  type = string
}

variable "DYNDNSPASS" {
  type = string
}