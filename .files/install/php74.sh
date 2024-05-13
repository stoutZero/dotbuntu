#!/usr/bin/env zsh

echo "adding ondrej's ppa"
echo

sudo add-apt-repository ppa:ondrej/php

echo
echo "ondrej's ppa added"

echo 'installing php & redis via apt'
echo

sudo apt install -y php7.4-fpm \
  php7.4-cli \
  php7.4-bcmath \
  php7.4-common \
  php7.4-curl \
  php7.4-gd \
  php7.4-igbinary \
  php7.4-imagick \
  php7.4-json \
  php7.4-mbstring \
  php7.4-opcache \
  php7.4-pgsql \
  php7.4-readline \
  php7.4-redis \
  php7.4-xml \
  php7.4-zip \
  redis-server

echo
echo 'php & redis installed via apt'
