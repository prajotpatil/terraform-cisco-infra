terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "~> 2.0"
    }
  }
}
resource "aci_vlan_pool" "this" {
  name       = var.vlan_pool_name
  alloc_mode = "static"
}

resource "aci_ranges" "this" {
  vlan_pool_dn = aci_vlan_pool.this.id
  from         = "vlan-${var.vlan_range_from}"
  to           = "vlan-${var.vlan_range_to}"
}

resource "aci_physical_domain" "this" {
  name                      = var.physical_domain_name
  relation_infra_rs_vlan_ns = aci_vlan_pool.this.id
}

resource "aci_attachable_access_entity_profile" "this" {
  name = var.aep_name

  relation_to_domains = [
    {
      target_dn = aci_physical_domain.this.id
    }
  ]
}

resource "aci_leaf_access_port_policy_group" "this" {
  name                        = var.ipg_name
  relation_infra_rs_att_ent_p = aci_attachable_access_entity_profile.this.id
}

resource "aci_leaf_interface_profile" "this" {
  name = var.interface_profile_name
}

resource "aci_access_port_selector" "this" {
  leaf_interface_profile_dn      = aci_leaf_interface_profile.this.id
  name                            = var.port_selector_name
  access_port_selector_type       = "range"
  relation_infra_rs_acc_base_grp  = aci_leaf_access_port_policy_group.this.id
}

resource "aci_access_port_block" "this" {
  access_port_selector_dn = aci_access_port_selector.this.id
  name                     = "block1"
  from_port                = var.port_block_from
  to_port                  = var.port_block_to
}

resource "aci_leaf_profile" "this" {
  name = var.leaf_profile_name
}

resource "aci_leaf_selector" "this" {
  leaf_profile_dn         = aci_leaf_profile.this.id
  name                     = "leaf-sel-${var.leaf_node_id}"
  switch_association_type = "range"
}

resource "aci_node_block" "this" {
  switch_association_dn = aci_leaf_selector.this.id
  name                    = "node-block-${var.leaf_node_id}"
  from_                   = var.leaf_node_id
  to_                     = var.leaf_node_id
}