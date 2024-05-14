#!/usr/bin/env zsh

# shellcheck disable=SC1090
source ~/.files/functions.sh

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

os="$(get_platform)"
hw="$(get_hw)"

repo=https://github.com/dunglas/frankenphp
filename="frankenphp-${os}-${hw}"

echo 'downloading latest frankenphp release from github'
echo

gh_dl "$repo" "$filename"
version="${version//v/}"

echo
echo 'latest frankenphp release downloaded'

echo 'installing frankenphp'
echo

if [ -f "$filename" ]; then
  sudo mv "$filename" /usr/local/bin/frankenphp
  sudo chmod a+x /usr/local/bin/frankenphp

  echo 'setcap to /usr/local/bin/frankenphp'
  sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/frankenphp
  sudo chown www-data: /usr/local/bin/frankenphp
fi

echo
echo 'frankenphp installed'

echo 'installing redis via apt'
echo

sudo apt install -y redis-server

echo
echo 'redis installed via apt'
