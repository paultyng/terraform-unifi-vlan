data "unifi_ap_group" "default" {
}

data "unifi_user_group" "default" {
}

resource "unifi_wlan" "wlan" {
  count = var.ssid == "" ? 0 : 1

  name            = var.ssid
  security        = "wpapsk"
  passphrase      = var.passphrase
  wpa3_support    = var.wpa3_support
  wpa3_transition = var.wpa3_transition
  pmf_mode        = var.pmf_mode

  is_guest          = var.is_guest
  multicast_enhance = var.multicast_enhance
  no2ghz_oui        = var.no2ghz_oui

  network_id   = unifi_network.vlan.id
  ap_group_ids = [data.unifi_ap_group.default.id]
  wlan_band    = "both"

  user_group_id = data.unifi_user_group.default.id

  minimum_data_rate_2g_kbps = var.minimum_data_rate_2g_kbps
  minimum_data_rate_5g_kbps = var.minimum_data_rate_5g_kbps
}
