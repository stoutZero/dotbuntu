#!/usr/bin/env bash

sudo apt install software-common \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg

if [ ! -d /etc/apt/keyrings ]; then
  echo 'ensuring keyrings dir exists'
  echo

  sudo install -m 0755 -d /etc/apt/keyrings
  echo
  echo 'keyrings dir exists'
fi

echo 'installing docker apt key & source'
echo

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
echo
echo 'docker apt key & source installed'

echo 'installing docker-ce & others...'
echo

sudo apt install -y docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
echo
echo 'docker-ce & others installed via apt'

echo "installing google's gvisor"
echo

curl -fsSL https://gvisor.dev/archive.key | sudo gpg --dearmor -o /usr/share/keyrings/gvisor-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gvisor-archive-keyring.gpg] https://storage.googleapis.com/gvisor/releases release main" | sudo tee /etc/apt/sources.list.d/gvisor.list > /dev/null

sudo apt-get update && sudo apt-get install -y docker runsc
echo
echo "google's gvisor installed"
