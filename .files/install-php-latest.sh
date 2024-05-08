#!/usr/bin/env bash

echo "adding ondrej's ppa"
echo

sudo add-apt-repository ppa:ondrej/php

echo
echo "ondrej's ppa added"

echo 'apt update'
echo

sudo apt update

echo
echo "apt updated"

echo 'installing php & redis via apt'
echo

sudo apt install -y php \
  php-fpm \
  php-bcmath \
  php-cli \
  php-common \
  php-curl \
  php-gd \
  php-igbinary \
  php-imagick \
  php-json \
  php-mbstring \
  php-opcache \
  php-pgsql \
  php-readline \
  php-redis \
  php-xml \
  php-zip \
  redis-server

echo
echo 'php & redis installed via apt'
