# Configure the Azure Provider get info with az account list
provider "azurerm" {
  version = "=2.20.0"
  subscription_id = var.SUBSCRIPTION_ID
  tenant_id       = var.TENANT_ID
  features { }
}

# Create a resource group
resource "azurerm_resource_group" "RG1" {
  name     = var.RG_NAME
  location = var.RG_LOCATION
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "AARG_VNET" {
  name                = var.VNET_NAME
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  address_space       = [var.VNET_ADDRESS_SPACE]
}

resource "azurerm_subnet" "SUBNET1" {
  name                 = var.SUBNET1_NAME
  resource_group_name  = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.AARG_VNET.name
  address_prefixes     = [var.SUBNET1_ADDRESS_SPACE]
}

resource "azurerm_public_ip" "AATestPublicIp1" {
  name                = "AATestPublicIp1"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  allocation_method   = "Static"

  tags = {
    environment = "AATEST"
  }
}

resource "azurerm_network_interface" "NIC1" {
  name                = "NIC1"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SUBNET1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.AATestPublicIp1.id
  }
}

resource "azurerm_linux_virtual_machine" "AA-UB1" {
  name                = "AA-UB1"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  size                = "Standard_F2"
  admin_username      = "aarato"
  network_interface_ids = [
    azurerm_network_interface.NIC1.id,
  ]

  admin_ssh_key {
    username   = var.VM_ADMIN_USERNAME
    public_key = file(var.VM_ADMIN_SSH_KEY)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}