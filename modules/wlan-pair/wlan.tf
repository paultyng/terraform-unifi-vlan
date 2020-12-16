# controller v5
data "unifi_wlan_group" "default" {
  count = var.controller_v5 ? 1 : 0
}

# controller v6
data "unifi_ap_group" "default" {
  count = var.controller_v5 ? 0 : 1
}

data "unifi_user_group" "default" {
}

resource "unifi_wlan" "wlan" {
  count = var.ssid == "" ? 0 : 1

  name       = var.ssid
  security   = "wpapsk"
  passphrase = var.passphrase

  is_guest          = var.is_guest
  multicast_enhance = var.multicast_enhance

  # controller v5
  vlan_id       = var.controller_v5 ? var.vlan_id : null
  wlan_group_id = var.controller_v5 ? data.unifi_wlan_group.default[0].id : null

  # controller v6
  network_id   = var.controller_v5 ? null : unifi_network.vlan.id
  ap_group_ids = var.controller_v5 ? null : [data.unifi_ap_group.default[0].id]

  user_group_id = data.unifi_user_group.default.id
}
