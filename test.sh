#!/bin/bash

# Exit on any error encountered
set -e

# Update the system
echo "Updating system..."
sudo apt-get update -y

# Install required packages
echo "Installing required packages..."
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y

# Add Docker's official GPG key
echo "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository to APT sources
echo "Adding Docker repository..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package database with Docker packages
echo "Updating package database..."
sudo apt-get update -y

# Install Docker CE
echo "Installing Docker CE..."
sudo apt-get install docker-ce -y

# Add current user to the Docker group
echo "Adding current user to Docker group..."
sudo usermod -aG docker ${USER}

# Install Docker Compose
echo "Installing Docker Compose..."
# Check for the latest version on the release page: https://github.com/docker/compose/releases
DOCKER_COMPOSE_VERSION="1.29.2"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Print Docker and Docker Compose version
echo "Installation complete."
echo "Docker version:"
sudo docker --version
echo "Docker Compose version:"
sudo docker-compose --version
