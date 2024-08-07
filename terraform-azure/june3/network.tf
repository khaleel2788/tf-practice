resource "azurerm_resource_group" "infra_rg" {
    name        = "fromtf"   
    location    = "Central US"
}

resource "azurerm_virtual_network" "ntier" {
    name                    = "ntier"
    resource_group_name     = azurerm_resource_group.infra_rg.name
    location                = azurerm_resource_group.infra_rg.location
    address_space           = var.network_cidr
    depends_on              = [ 
      azurerm_resource_group.infra_rg
     ]
}

resource "azurerm_subnet" "subnets" {
    count                   = length(var.subnet_names)
    name                    = var.subnet_names[count.index]
    resource_group_name     = azurerm_resource_group.infra_rg.name
    virtual_network_name    = azurerm_virtual_network.ntier.name
    address_prefixes        = [cidrsubnet(var.network_cidr[0],8,count.index)]
    depends_on              = [ 
      azurerm_resource_group.infra_rg,
      azurerm_virtual_network.ntier
     ]
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "appnsg"
  location            = azurerm_resource_group.infra_rg.location
  resource_group_name = azurerm_resource_group.infra_rg.name

  security_rule {
    name                       = "portswithin"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.network_cidr[0]
    destination_address_prefix = "*"
  }
  depends_on              = [ 
      azurerm_resource_group.infra_rg
     ]
}

  resource "azurerm_network_security_group" "web_nsg" {
  name                = "webnsg"
  location            = azurerm_resource_group.infra_rg.location
  resource_group_name = azurerm_resource_group.infra_rg.name

  security_rule {
    name                       = "openssh"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "openhttp"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
depends_on              = [ 
      azurerm_resource_group.infra_rg
     ]
}