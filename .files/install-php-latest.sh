#!/usr/bin/env zsh

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

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

echo 'installing composer'
echo

if [ ! -f /usr/local/bin/composer ]; then
  EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
      >&2 echo 'ERROR: Invalid installer checksum'
      rm composer-setup.php
      exit 1
  fi

  php composer-setup.php --quiet

  rm composer-setup.php

  if [ -f composer.phar ]; then
    sudo mv composer.phar /usr/local/bin/composer
  fi
fi

echo
echo 'composer installed via apt'
