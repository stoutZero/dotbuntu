#!/usr/bin/env zsh

# shellcheck disable=SC1090
source ~/.files/functions.sh

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

if (( $(check_ppa 'ondrej/php') < 1))
then
  echo "adding ondrej's ppa"
  echo

  sudo add-apt-repository ppa:ondrej/php

  echo
  echo "ondrej's ppa added"
fi

echo 'installing php & redis via apt'
echo

sudo apt install -y php8.3-cli \
  php8.3-bcmath \
  php8.3-common \
  php8.3-curl \
  php8.3-gd \
  php8.3-igbinary \
  php8.3-imagick \
  php-json \
  php8.3-mbstring \
  php8.3-opcache \
  php8.3-pgsql \
  php8.3-readline \
  php8.3-redis \
  php8.3-xml \
  php8.3-zip \
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
