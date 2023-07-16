#!/bin/bash

# Update the dependencies
sudo apt-get update

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    
    # Install Docker dependencies
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Add Docker repository
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update the package index (again)
    sudo apt-get update
    
    # Install Docker
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Add current user to docker group
    sudo groupadd docker
    sudo usermod -aG docker $USER
    
    echo "Docker installed successfully!"
else
    echo "Docker is already installed."
fi

sudo apt-get install -y python3 python3-pip

# Install base dependencies for Ansible roles
sudo apt install ansible

# check ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "Ansible is installed but is not in the PATH. Adding Ansible to PATH..."
    export PATH=$PATH:$HOME/.local/bin" 
    echo "Ansible installed successfully!"
else
    echo "Ansible is already installed & is in the PATH."
fi