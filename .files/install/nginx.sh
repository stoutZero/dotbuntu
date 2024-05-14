#!/usr/bin/env zsh

# shellcheck disable=SC1090
source ~/.files/functions.sh

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

if (( $(check_ppa 'ondrej/nginx-mainline') < 1))
then
  echo "adding ondrej's ppa"
  echo

  sudo add-apt-repository -y ppa:ondrej/nginx-mainline

  echo
  echo "ondrej's ppa added"
fi

echo 'installing nginx via apt'
echo

sudo apt install -y nginx-full

echo
echo 'nginx installed via apt'
