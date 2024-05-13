#!/usr/bin/env bash

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

arch="$(get_arch)"

sudo apt install -y software-properties-common \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg

install_keyring

echo 'installing docker apt key & source'
echo

if [ ! -f /etc/apt/keyrings/docker.asc ]; then
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
fi

if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
  # shellcheck disable=SC1091
  echo \
    "deb [arch=${arch} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
fi

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

if [ ! -f /usr/share/keyrings/gvisor-archive-keyring.gpg ]; then
  curl -fsSL https://gvisor.dev/archive.key \
    | sudo gpg --dearmor -o /usr/share/keyrings/gvisor-archive-keyring.gpg
fi

if [ ! -f /etc/apt/sources.list.d/gvisor.list ]; then
  echo "deb [arch=${arch} signed-by=/usr/share/keyrings/gvisor-archive-keyring.gpg] https://storage.googleapis.com/gvisor/releases release main" \
    | sudo tee /etc/apt/sources.list.d/gvisor.list \
    > /dev/null

  sudo apt update
fi

sudo apt-get install -y runsc

echo
echo "google's gvisor installed"
