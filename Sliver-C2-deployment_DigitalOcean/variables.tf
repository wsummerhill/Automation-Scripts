variable "hostname" {
  type = string
  description = "Server hostname to create"
  default = "sliver-c2" # Server hostname
}

variable "region" {
  type = string
  description = "DigitalOcean region to create droplet in"
  default = "<REGION>"  # DigitalOcean region
}

variable "public_key_path" {
  type = string
  description = "SSH public key"
  default = "/path/to/pubkey.pub" # Create a new SSH key in DigitialOcean from a local key
}

variable "private_key_path" {
  type = string
  description = "SSH private key"
  default = "/path/to/privkey" # Private key to connect to droplet
}

variable "do_token" {
  type = string
  description = "DigitalOcean API token"
  default = "<DIGITALOCEAN-API-TOKEN>" # Your DigitalOcean API token
}

variable "ips_ufw_all" {
  type    = list
  description = "IP addresses to allow-list in UFW firewall rules"
  default = [
    "<IP-ADDRESS>",
    "<IP-ADDRESS>",
    "<IP-ADDRESS>"
  ]
}
