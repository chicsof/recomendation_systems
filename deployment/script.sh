#!/usr/bin/env bash
# Update
sudo yum update -y
# Install Docker
sudo amazon-linux-extras install docker -y
# Start
sudo service docker start
sudo bash -c "< /tmp/files/secret docker login -u gitlab+deploy-token-28672 --password-stdin registry.gitlab.com"
rm -rf /tmp/files/secret
# Create `web` network
sudo docker network create web


# Install `docker-compose` shell script
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.23.1/run.sh -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose


# Move all traefik files to opt
sudo mv /tmp/files/traefik /opt/traefik
# Fix ownership
sudo chown -R root:root /opt/traefik
# Create blank acme.json
sudo touch /opt/traefik/acme.json
sudo chmod 600 /opt/traefik/acme.json

# Move all rstudio files to opt
sudo mv /tmp/files/book_store /opt/book_store
sudo chown -R root:root /opt/book_store


# Start rstudio
cd /opt/book_store && sudo docker-compose up -d

# Start traefik
cd /opt/traefik && sudo docker-compose up -d
