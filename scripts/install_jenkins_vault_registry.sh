#!/bin/bash

# This script does the following things
# * vault  
# * Starts Vault and other pipeline services
# * Also installs vault cli to communicate with vault


# Install HashiCorp Vault (example for Ubuntu)
sudo apt-get install -y software-properties-common
sudo apt-add-repository --yes --update ppa:hashicorp/vault
sudo apt-get install -y vault

# Start services
sudo service vault start

# getting compose file & services
COMPOSE_FILE="${1:-docker-compose.yml}"
REGISTRY="${2:-registry}"
NGINX="${3:-nginx}"

#Starting registry & nginx service
echo "Setting up $REGISTRY & $NGINX in $COMPOSE_FILE"
docker compose -f "../$COMPOSE_FILE" up -d "$REGISTRY"
docker compose -f "../$COMPOSE_FILE" up -d "$NGINX"

echo "Services installed and started: Vault, Nginx and Docker Registry"

