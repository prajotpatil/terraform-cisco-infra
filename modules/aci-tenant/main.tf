terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "~> 2.0"
    }
  }
}
resource "aci_tenant" "this" {
  name        = var.tenant_name
  description = "Managed by Terraform - do not edit manually"
}

resource "aci_vrf" "this" {
  tenant_dn = aci_tenant.this.id
  name      = var.vrf_name
}

resource "aci_bridge_domain" "this" {
  tenant_dn          = aci_tenant.this.id
  relation_fv_rs_ctx = aci_vrf.this.id
  name               = var.bd_name
}

resource "aci_subnet" "this" {
  parent_dn = aci_bridge_domain.this.id
  ip        = var.bd_subnet
}

resource "aci_application_profile" "this" {
  tenant_dn = aci_tenant.this.id
  name      = var.app_profile_name
}

resource "aci_application_epg" "this" {
  application_profile_dn = aci_application_profile.this.id
  name                    = var.epg_name
  relation_fv_rs_bd       = aci_bridge_domain.this.id
}

resource "aci_epg_to_static_path" "this" {
  application_epg_dn = aci_application_epg.this.id
  tdn                = "topology/pod-1/paths-${var.leaf_node_id}/pathep-[${var.port_id}]"
  encap              = var.vlan_encap
}