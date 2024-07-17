
data "azurerm_subnet" "websubnet" {
    resource_group_name             = azurerm_resource_group.infra_rg.name
    virtual_network_name            = azurerm_virtual_network.ntier.name
    name                            = var.websubnet

    depends_on = [
      azurerm_subnet.subnets
    ]

}

# public ip 

resource "azurerm_public_ip" "webip" {
    resource_group_name             = azurerm_resource_group.infra_rg.name
    location                        = azurerm_resource_group.infra_rg.location
    name                            = "webpublicip" 
    allocation_method               = "Dynamic"

}

resource "azurerm_network_interface" "webnic" {
    name                            = "webnic"
    resource_group_name             = azurerm_resource_group.infra_rg.name
    location                        = azurerm_resource_group.infra_rg.location
    ip_configuration {
      name                          = "appipconfig"
      subnet_id                     = data.azurerm_subnet.websubnet.id
      public_ip_address_id          = azurerm_public_ip.webip.id
      private_ip_address_allocation = "Dynamic"
    }

}

resource "azurerm_network_interface_security_group_association" "webnsgassociation" {
    network_interface_id            = azurerm_network_interface.webnic.id
    network_security_group_id       = azurerm_network_security_group.web_nsg.id
}


resource "azurerm_linux_virtual_machine" "webserver" {
    name                            = "webserver"
    resource_group_name             = azurerm_resource_group.infra_rg.name
    location                        = azurerm_resource_group.infra_rg.location
    size                            = var.vmsize
    admin_username                  = "qtdevops" 
    admin_password                  = "motherindia@123"
    network_interface_ids           = [azurerm_network_interface.webnic.id] 
    disable_password_authentication = false

    source_image_reference {
        publisher                   = "Canonical"
        offer                       = "0001-com-ubuntu-server-focal"
        sku                         = "20_04-lts-gen2"
        version                     = "latest"
    }

    os_disk {
        caching                     = "ReadWrite"
        storage_account_type        = "Standard_LRS"
  }

}