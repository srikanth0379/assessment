resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "sri-aks"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "sri-aks-dns"
  kubernetes_version  = var.kube_version

  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  default_node_pool {
    name            = "default"
    node_count      = "3"
    vm_size         = "Standard_D2s_v3"
    os_disk_size_gb = 30
    vnet_subnet_id  = azurerm_subnet.subnet.id
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    service_cidr       = "10.0.0.0/16"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  role_based_access_control_enabled = true

  identity {
    type = "SystemAssigned"
  }
}

output "client_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate
}

output "kube_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.cluster.kube_config_raw
}
