#!/bin/bash
{* Update apt *}
sudo apt-get update -y

{* Install depedencies *}
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  gnupg-agent \
  software-properties-common
  python3-pip python3-venv \
  git

{* Install Git *}

{* Install Docker and Docker Compose *}
{* Add GPG key and set up the repository *}
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
{* Install the Docker Engine *}
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

{* Add ubuntu user to the docker group, allowing you to run docker commands as the ubuntu user *}
sudo groupadd docker
