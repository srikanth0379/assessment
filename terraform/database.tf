resource "azurerm_postgresql_server" "dbserver" {
  name                = "database-server"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku_name = "GP_Gen5_4"
  version  = 11

  storage_mb                   = 10240
  backup_retention_days        = 20
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  administrator_login              = "psqladmin"
  administrator_login_password     = "postgres"
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
  public_network_access_enabled    = true

}

resource "azurerm_postgresql_database" "db" {
  name                = "backenddb"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.dbserver.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_virtual_network_rule" "rule" {
  name                = "postgresql-vnet-rule"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.dbserver.name
  subnet_id           = azurerm_subnet.subnet.id
}

resource "azurerm_private_dns_zone" "psql_dns_zone" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "private_link_services" {
  name                 = "plink-services"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.2.1.0/24"]

  enforce_private_link_endpoint_network_policies = true

  service_endpoints = [
    "Microsoft.Sql"
  ]
}

resource "azurerm_private_endpoint" "psql_endpoint" {
  name                = "psql-private-endpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_link_services.id

  private_dns_zone_group {
    name = "private-dns-zone-group"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.psql_dns_zone.id
    ]
  }

  private_service_connection {
    name                           = "psql-private-link"
    private_connection_resource_id = azurerm_postgresql_server.dbserver.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "psql_vnet_link" {
  name                  = "pslq-dns-zone-vnet-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.psql_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
