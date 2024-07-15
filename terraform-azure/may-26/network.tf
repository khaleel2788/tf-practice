resource "azurerm_resource_group" "infra_rg" {
    name        = "fromtf"   
    location    = "South India"
}

resource "azurerm_virtual_network" "ntier" {
    name                    = "ntier"
    resource_group_name     = azurerm_resource_group.infra_rg.name
    location                = azurerm_resource_group.infra_rg.location
    address_space           = var.network_cidr
}

resource "azurerm_subnet" "subnets" {
    count                   = length(var.subnet_names)
    name                    = var.subnet_names[count.index]
    resource_group_name     = azurerm_resource_group.infra_rg.name
    virtual_network_name    = azurerm_virtual_network.ntier.name
    address_prefixes        = [cidrsubnet(var.network_cidr[0],8,count.index)]
}
