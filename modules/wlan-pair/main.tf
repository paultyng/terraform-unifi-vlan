terraform {
  required_version = ">= 0.13.0"

  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = ">= 0.32.0"
    }
  }
}

variable "name" {
  description = "Name of the network"
  type        = string
}

variable "ssid" {
  description = "Wireless SSID, leave this blank if you do not want a wireless network created."
  type        = string
  default     = ""
}

variable "passphrase" {
  description = "Wireless passphrase (WPAPSK)"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Network domain name, defaults to the lowercase version of <name>.local."
  type        = string
  default     = ""
}

variable "subnet_cidr" {
  type = string
  # TODO: calculate this automatically given an index/octet or something?
  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.subnet_cidr))
    error_message = "A valid subnet CIDR is required."
  }
}

variable "vlan_id" {
  type = number
}

variable "igmp_snooping" {
  type    = bool
  default = false
}

variable "is_guest" {
  type    = bool
  default = false
}

variable "multicast_enhance" {
  type    = bool
  default = false
}

variable "no2ghz_oui" {
  type    = bool
  default = false
}

variable "minimum_data_rate_2g_kbps" {
  type    = number
  default = 6000
}

variable "minimum_data_rate_5g_kbps" {
  type    = number
  default = null
}
