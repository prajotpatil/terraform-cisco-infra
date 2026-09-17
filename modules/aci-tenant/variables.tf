variable "tenant_name" {
  type        = string
  description = "Name of the ACI tenant"
}

variable "vrf_name" {
  type        = string
  description = "Name of the VRF (routing/isolation boundary)"
}

variable "bd_name" {
  type        = string
  description = "Name of the Bridge Domain"
}

variable "bd_subnet" {
  type        = string
  description = "Subnet for the Bridge Domain, e.g. 10.10.10.1/24"
}

variable "app_profile_name" {
  type        = string
  description = "Name of the application profile"
}

variable "epg_name" {
  type        = string
  description = "Name of the EPG"
}

variable "vlan_encap" {
  type        = string
  description = "VLAN encapsulation for static path binding, e.g. vlan-100"
}

variable "leaf_node_id" {
  type        = string
  description = "Leaf switch node ID, e.g. 101"
}

variable "port_id" {
  type        = string
  description = "Port path, e.g. eth1/10"
}