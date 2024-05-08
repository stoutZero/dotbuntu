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

if ! command -v bat > /dev/null 2>&1 ; then
  echo -n 'installing bat...'

  wget -q https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb

  sudo dpkg -i bat_0.24.0_amd64.deb

  rm -f bat_0.24.0_amd64.deb

  echo ' done'
fi
