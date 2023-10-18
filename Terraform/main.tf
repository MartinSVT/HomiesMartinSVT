terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "ResGroup" {
  name     = var.RGName
  location = var.RGLocation
}

resource "azurerm_service_plan" "AzServicePlan" {
  name                = var.ASPName
  resource_group_name = azurerm_resource_group.ResGroup.name
  location            = azurerm_resource_group.ResGroup.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_mssql_server" "AzSQLServer" {
  name                         = var.SQLSname
  resource_group_name          = azurerm_resource_group.ResGroup.name
  location                     = azurerm_resource_group.ResGroup.location
  version                      = "12.0"
  administrator_login          = var.SQLUsername
  administrator_login_password = var.SQLPassword
}

resource "azurerm_mssql_database" "AzDB" {
  name           = var.SQLDBName
  server_id      = azurerm_mssql_server.AzSQLServer.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "AzFirewall" {
  name             = var.FRName
  server_id        = azurerm_mssql_server.AzSQLServer.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_linux_web_app" "AzLinuxApp" {
  name                = var.AppSName
  resource_group_name = azurerm_resource_group.ResGroup.name
  location            = azurerm_resource_group.ResGroup.location
  service_plan_id     = azurerm_service_plan.AzServicePlan.id

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.AzSQLServer.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.AzDB.name};User ID=${azurerm_mssql_server.AzSQLServer.administrator_login};Password=${azurerm_mssql_server.AzSQLServer.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
}

resource "azurerm_app_service_source_control" "AzRepo" {
  app_id                 = azurerm_linux_web_app.AzLinuxApp.id
  repo_url               = var.RepoURL
  branch                 = "main"
  use_manual_integration = true
}