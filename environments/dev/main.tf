terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "~> 2.0"
    }
  }
}

variable "aci_password" {
  type      = string
  sensitive = true
}

provider "aci" {
  username = "admin"
  password = var.aci_password
  url      = "https://sandboxapicdc.cisco.com"
  insecure = true
}

module "aci_logical" {
  source           = "../../modules/aci-tenant"
  tenant_name      = "dev-terraform-lab-tenant"
  vrf_name         = "dev-vrf"
  bd_name          = "dev-bd"
  bd_subnet        = "10.10.10.1/24"
  app_profile_name = "dev-app"
  epg_name         = "dev-epg"
  vlan_encap       = "vlan-100"
  leaf_node_id     = "101"
  port_id          = "eth1/10"
}

module "aci_access_policy" {
  source                 = "../../modules/aci-access-policy"
  vlan_pool_name         = "dev-vlan-pool"
  vlan_range_from        = "100"
  vlan_range_to          = "200"
  physical_domain_name   = "dev-phys-domain"
  aep_name               = "dev-aep"
  ipg_name               = "dev-ipg"
  interface_profile_name = "dev-int-profile"
  port_selector_name     = "dev-port-sel"
  port_block_from        = "10"
  port_block_to          = "10"
  leaf_profile_name      = "dev-leaf-profile"
  leaf_node_id           = "101"
}