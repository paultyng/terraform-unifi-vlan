output "max_rule_index" {
  value = max([for rule in unifi_firewall_rule.rule : rule.rule_index]...)
}