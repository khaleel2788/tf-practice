
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
    admin_username                  = var.username 
    admin_password                  = var.password
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
  // terraform provisioners -> remote-exec
    connection {
      type      = "ssh"
      user      = var.username
      password  = var.password
      host      = self.public_ip_address
      // actually self.public_ip_address_id I assuming let's see
    }

// If you have many things to install then use the following
    # provisioner "file" {
    #     source = "./scripts/installapache2.sh"
    #     destination = "/temp/installationapache2.sh"
      
    # }

    provisioner "remote-exec" {
        inline = [ 
            "#!/bin/bash",
            "sudo apt update",
            "sudo apt install apache2 -y",
            "sudo apt install tree openjdk-11-jdk -y"
         ]

         // script = "/tmp/installapache2.sh"
      
    }

}

resource "null_resource" "forprovisioning" {
    triggers    = {
      "execute"       = var.increment_execute
    }
    connection {
      type      = "ssh"
      user      = var.username
      password  = var.password
      host      = azurerm_linux_virtual_machine.webserver.public_ip_address
      // actually self.public_ip_address_id I assuming let's see
    }

// If you have many things to install then use the following
    # provisioner "file" {
    #     source = "./scripts/installapache2.sh"
    #     destination = "/temp/installationapache2.sh"
      
    # }

    provisioner "remote-exec" {
        inline = [ 
            "#!/bin/bash",
            "sudo apt update",
            "sudo apt install software-properties-common-y",
            "sudo add-apt-repository --yes --update ppa:ansible/ansible",
            "sudo apt install ansible -y",
            "ansible --version",
            "ansbile-playbook --version"
         ]

         // script = "/tmp/installapache2.sh"
      
    }
  
}