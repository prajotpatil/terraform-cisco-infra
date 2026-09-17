output "tenant_dn" {
  value = aci_tenant.this.id
}

output "epg_dn" {
  value = aci_application_epg.this.id
}