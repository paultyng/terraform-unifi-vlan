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

# Create the VLAN and SSID pairing
module "vlans" {
  source = "../../modules/wlan-pair"

  name = "IoT Network"

  ssid              = "my-iot-ssid"
  passphrase        = "things go on this network"
  subnet_cidr       = "10.0.100.0/24"
  vlan_id           = 100
  domain_name       = "iot.local"
  multicast_enhance = true
}
