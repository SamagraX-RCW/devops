#!/bin/bash

# This script does the following things
# * Install Docker
# * Installs Vault Cli and Ansible

# Update the dependencies
sudo apt-get update

# Install dependencies
sudo apt-get install ca-certificates curl gnupg

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    
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
else
    echo "Docker is already installed."
fi

#installing vault cli for generating the vault token
sudo apt update && sudo apt install gpg
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install vault

#install ansible 
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
sudo apt install make

#Get public ip-address
public_ip=$(curl -s ifconfig.co)

echo " " >> ~/devops/ansible_workspace_dir/roles/swarm_manager_init/vars/main.yml
echo "swarm_master_ip_address: ${public_ip}" >> ~/devops/ansible_workspace_dir/roles/swarm_manager_init/vars/main.yml
echo "swarm_master_ip_address: ${public_ip}" >> ~/devops/ansible_workspace_dir/roles/swarm_workers_init/vars/main.yml
echo "swarm_master_ip_address: ${public_ip}" >> ~/devops/ansible_workspace_dir/roles/swarm_init/vars/main.yml