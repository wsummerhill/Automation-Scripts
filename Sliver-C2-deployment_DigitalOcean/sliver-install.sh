#!/bin/bash

# Documentation: https://github.com/BishopFox/sliver/wiki/Getting-Started
# Reference: https://blog.port9.org/posts/sliver-c2-intro/

# Read IPs to allow-list from command-line arguments
ips=("$@")

echo Sleeping until device is ready...
sleep 10

# Stop apache if its started automatically
service apache2 stop

cd /tmp
apt update -y
apt update --fix-missing -y
apt install git mingw-w64 net-tools -y

echo Sleeping for 5 seconds...
sleep 5

# UFW firewall rules - Takes input IPs from variables.tf "ips_ufw" variable
for IP in "${ips[@]}"
do
  ufw allow from "$IP"
done
ufw --force enable # Start UFW firewall

# Sliver install
curl https://sliver.sh/install|sudo bash
systemctl status sliver --no-pager
echo Sliver running in Daemon mode!

# Create user config
cd /root
IP=`curl https://ifconfig.me/ip`
./sliver-server operator --name sliver-user --lhost "$IP" --save /root/sliver-user.cfg

exit