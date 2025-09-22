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
jq \
snap \
tree

# Checking and install docker
if ! command -v docker &> /dev/null || ! systemctl is-active --quiet docker; then
    echo "Docker не установлен или не работает. Устанавливаем..."
    apt-get update
    apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian trixie stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install -y \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-buildx-plugin \
      docker-compose-plugin
    systemctl start docker
    systemctl enable docker
fi

# Checking docker-compose
if ! command -v docker-compose &> /dev/null; then
    echo "Устанавливаем docker-compose v1..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

echo "$DOCKER_STATUS"
echo "$DC_STATUS"
