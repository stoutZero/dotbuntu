#!/usr/bin/env bash

mkdir -p "$HOME/tmp/"
cd "$HOME/tmp/"

echo 'installing essential packages'
echo

release="$(lsb_release -sr)"

pkgs="software-properties-common \
brotli \
curl \
dnsutils \
git \
gzip \
htop \
nano \
traceroute \
unhide \
wget \
zip \
zstd"

if [ "x18.04" !== "x${release}" ] ; then
  pkgs="${pkgs} fzf micro"
fi

sudo apt install -y "$pkgs"

if [ "x18.04" === "x${release}" ] ; then
  echo 'installing micro & fzf'
  echo

  curl https://getmic.ro | bash

  sudo mv ./micro /usr/local/bin
  sudo chown root: /usr/local/bin/micro

  wget -q https://github.com/junegunn/fzf/releases/download/0.52.0/fzf-0.52.0-linux_"${arch}".tar.gz

  tar xzf fzf-0.52.0-linux_"${arch}".tar.gz

  sudo mv ./fzf /usr/local/bin
  sudo chown root: /usr/local/bin/fzf

  echo
  echo 'micro & fzf installed'
fi

echo
echo 'essential packages installed'

arch="$(dpkg --print-architecture)"

if ! command -v bat > /dev/null 2>&1 ; then
  echo 'installing bat'
  echo

  wget -q https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_"${arch}".deb

  sudo dpkg -i bat_0.24.0_"${arch}".deb

  rm -f bat_0.24.0_"${arch}".deb

  echo
  echo 'bat installed'
fi
