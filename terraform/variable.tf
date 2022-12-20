variable "vnetname" {
  type = string
  default = "demo-vnet"
}

variable "kube_version" {
  type    = string
  default = "1.23.12"
}

variable "api_server_authorized_ip_ranges" {
  type        = list(string)
  description = "Kubernetes API authorized IPv4 CIDR ranges"
  default     = []
}
