locals {
  domain_name = var.domain_name == "" ? "${var.name}.local" : var.domain_name
}

resource "unifi_network" "vlan" {
  name    = var.name
  subnet  = var.subnet_cidr
  vlan_id = var.vlan_id

  dhcp_start = cidrhost(var.subnet_cidr, 6)
  dhcp_stop  = cidrhost(var.subnet_cidr, 254)

  domain_name = local.domain_name

  igmp_snooping = var.igmp_snooping

  dhcp_lease   = 86400
  dhcp_enabled = true
  purpose      = "corporate"
}
