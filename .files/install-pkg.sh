#!/usr/bin/env bash

echo 'installing essential softwares'
echo

sudo apt install software-common \
  nano \
  git \
  zip \
  gzip \
  zstd \
  brotli \
  curl \
  wget \
  fzf \
  micro \
  htop \
  traceroute \
  dnsutils \
  unhide

echo
echo 'essential softwares installed'

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
