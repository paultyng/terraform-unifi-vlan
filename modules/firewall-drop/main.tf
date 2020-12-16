terraform {
  required_version = ">= 0.13.0"

  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = ">= 0.13.0"
    }
  }
}

variable "networks" {
  type        = map(string)
  description = "A map of network names and IDs (names are used in rule descriptions)"

  validation {
    condition     = length(var.networks) < 10
    error_message = "A maximum of 9 networks are supported due to the rule indexing scheme."
  }
}

# TODO: re-investigate template deprecation for this use case...
variable "rule_prefix" {
  type    = string
  default = ""
}

variable "rule_index_start" {
  type    = number
  default = 2900
}