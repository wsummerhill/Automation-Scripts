#!/bin/bash

sudo apt-get update -y

# Install base stuff
sudo apt install net-tools -y
sudo apt-get install plocate -y
sudo apt install python3-pip -y
sudo apt  install jq -y

cd ~/


# Install Go
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -xvf go1.21.0.linux-amd64.tar.gz
sudo mv go /usr/local
echo "" >> ~/.bashrc
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.bashrc
source ~/.bashrc


# Install security tools
sudo apt install nmap -y
go install github.com/OJ/gobuster/v3@latest	# gobuster
go install github.com/ffuf/ffuf/v2@latest 	# ffuf
go install github.com/bitquark/shortscan/cmd/shortscan@latest	# shortscan
git clone https://github.com/christophetd/censys-subdomain-finder.git 	# censys domain enum
go install github.com/sensepost/gowitness@latest	# Gowitness


# Project discovery tools
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest


# Other stuff
