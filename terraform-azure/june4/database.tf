resource "azurerm_mssql_server" "dbserver" {
    count                           = var.createdb ? 1 : 0 
    name                            = var.servername
    resource_group_name             = azurerm_resource_group.infra_rg.name
    location                        = azurerm_resource_group.infra_rg.location
    version                         = "12.0"
    administrator_login             = var.username 
    administrator_login_password    = var.password

    depends_on              = [
        azurerm_subnet.subnets
    ]
    }

resource "azurerm_mssql_database" "sqldb" {
    count                           = var.createdb ? 1 : 0 
    name                            = var.dbname 
    server_id                       = azurerm_mssql_server.dbserver[0].id
    sku_name                        = "Basic"
    }