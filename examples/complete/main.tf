terraform {
  required_version = ">= 0.13"

  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = ">= 0.18.0"
    }
  }
}

provider "unifi" {
  # TODO: configure your provider as necessary or use environment variables
}

locals {
  vlans = {
    "Guest" = {
      "vlan_id"           = 30
      "third_octet"       = 3
      "igmp_snooping"     = false
      "ssid"              = "my-guest-network"
      "passphrase"        = "guest-passphrase"
      "is_guest"          = true
      "multicast_enhance" = false
    },
    "IoT" = {
      "vlan_id"           = 50
      "third_octet"       = 5
      "igmp_snooping"     = true
      "ssid"              = "my-iot-network"
      "passphrase"        = "iot-passphrase"
      "is_guest"          = false
      "multicast_enhance" = true
    },
  }
}

# Create the VLANs and SSID pairings
module "vlans" {
  source   = "../../modules/wlan-pair"
  for_each = local.vlans

  name = each.key

  ssid              = each.value.ssid
  passphrase        = each.value.passphrase
  subnet_cidr       = join("", ["10.0.", each.value.third_octet, ".0/24"])
  vlan_id           = each.value.vlan_id
  igmp_snooping     = each.value.igmp_snooping
  domain_name       = "${lower(each.key)}.local"
  is_guest          = each.value.is_guest
  multicast_enhance = each.value.multicast_enhance
}

# Drop cross traffic between the Guest and IoT VLANs
module "vlan_firewall" {
  source = "../../modules/firewall-drop"

  networks = { for name in keys(local.vlans) : name => module.vlans[name].network.id }

  # set a prefix to display in the UI
  rule_prefix = "[tf] vlan-firewall "
}
