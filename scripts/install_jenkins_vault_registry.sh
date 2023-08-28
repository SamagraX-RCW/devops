#!/bin/bash

# Update the dependencies
sudo apt-get update

# Install dependencies
sudo apt-get install ca-certificates curl gnupg

# Install Docker dependencies
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
sudo groupadd docker
sudo usermod -aG docker $USER

echo "Docker installed successfully!"

# Install Jenkins
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins

# Install HashiCorp Vault (example for Ubuntu)
sudo apt-get install -y software-properties-common
sudo apt-add-repository --yes --update ppa:hashicorp/vault
sudo apt-get install -y vault

# Start services
sudo service jenkins start
sudo service vault start

# getting compose file & services
COMPOSE_FILE="${1:-docker-compose.yml}"
REGISTRY="${2:-registry}"
NGINX="${3:-nginx}"

#Starting registry & nginx service
echo "Setting up $REGISTRY & $NGINX in $COMPOSE_FILE"
docker compose -f "$COMPOSE_FILE" up -d "$REGISTRY"
docker compose -f "$COMPOSE_FILE" up -d "$NGINX"


echo "Services installed and started: Jenkins, Vault, Docker Registry"

#installing vault cli for generating the vault token
sudo apt update && sudo apt install gpg
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install vault
