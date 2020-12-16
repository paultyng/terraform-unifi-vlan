locals {
  all_network_names = toset(keys(var.networks))

  rules = { for pair in setproduct(local.all_network_names, local.all_network_names) : "${pair[0]} to ${pair[1]}" => {
    src_name = pair[0]
    dst_name = pair[1]
  } if pair[0] != pair[1] }
}

resource "unifi_firewall_rule" "rule" {
  for_each = local.rules

  // TODO syntax bug: "${var.foo}${var.bar}"
  // TODO: literal index syntax here...
  name    = "${var.rule_prefix}drop ${each.key}"
  action  = "drop"
  ruleset = "LAN_IN"

  rule_index = var.rule_index_start + index(sort(keys(local.rules)), each.key)

  protocol = "all"

  src_network_id = var.networks[each.value.src_name]
  dst_network_id = var.networks[each.value.dst_name]
}
