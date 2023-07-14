
provider "digitalocean" {
  token = var.do_token
}

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Use an exising local SSH key to upload to DO
resource "digitalocean_ssh_key" "local_ssh_pubkey" { 
  name       = "id_rsa_do"
  public_key = file(var.public_key_path)
}

resource "digitalocean_droplet" "SliverC2" {
  image  = "ubuntu-22-10-x64"
  name   = var.hostname
  region = var.region
  size   = "s-1vcpu-1gb"
  tags   = ["Sliver-C2"]
  # SSH keys: https://nickolasfisher.com/blog/How-to-Create-a-Digital-Ocean-Droplet-using-Terraform
  ssh_keys = [digitalocean_ssh_key.local_ssh_pubkey.fingerprint]  # Upload local SSH key to DigitalOcean

  connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_key_path)
      timeout     = "2m"
  }
  
  # Provisioning the sliver installation file
  provisioner "file" {
    source      = "./sliver-install.sh"
    destination = "/tmp/sliver-install.sh"
  }

  # Execute standard updates and Sliver installation script
  ## Take "ufw allow" IPs as input variable to allow-list
  provisioner "remote-exec" {
    inline = [
      # Run Sliver installation script
      "chmod +x /tmp/sliver-install.sh",
      "sudo /tmp/sliver-install.sh ${join(" ", var.ips_ufw_all)}",
      "echo Done Sliver C2 installation!"
    ]
  }

  # Print droplet external IP address
  provisioner "local-exec" {
    command = "echo The Sliver server IP address is ${self.ipv4_address}"
  }

  provisioner "local-exec" {
    command = <<-EOT
        GREEN=$(tput setaf 2); echo $GREEN Downloading \"sliver-user.cfg\" file to connect to C2 server!!
        scp -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i ${var.private_key_path} root@${self.ipv4_address}:/root/sliver-user.cfg .
    EOT
  }
}

output "droplet_ip_addresses" {
  value = digitalocean_droplet.SliverC2.ipv4_address
}

output "ssh_connect" {
  value = "ssh -i ${var.private_key_path} root@${digitalocean_droplet.SliverC2.ipv4_address}"
}

output "sliver_config_import" {
  value = "/path/to/sliver-client_OS import sliver-user.cfg"
}
