#!/usr/bin/env bash

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

arch="$(dpkg --print-architecture)"

if ! command -v bat > /dev/null 2>&1 ; then
  echo -n 'installing bat...'

  wget -q https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_"${arch}".deb

  sudo dpkg -i bat_0.24.0_"${arch}".deb

  rm -f bat_0.24.0_"${arch}".deb

  echo ' done'
fi
