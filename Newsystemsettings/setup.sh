#This file is intended for the basic configuration of the created workstation.
#!/bin/bash
DOCKER_STATUS=$(systemctl status docker)
DC_STATUS=$(docker compose version)

if [ "$EUID" -ne 0]; then 
  echo "ERROR: This script must be run as root"
  exit 1
fi
#Packages install
apt-get update && apt-get install -y \
sudo \
vim \
git \
python3-full \
jq

#docker install
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker
systemctl enable docker

#Install docker-compose
apt-get update
apt-get install docker-compose-plugin

echo "$DOCKER_STATUS"
echo "$DC_STATUS"
