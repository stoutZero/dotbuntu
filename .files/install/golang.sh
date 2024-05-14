#!/usr/bin/env zsh

# shellcheck disable=SC1090
source ~/.files/functions.sh

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

if (( $(check_ppa 'longsleep/golang-backports') < 1))
then
  echo "adding ppa:longsleep/golang-backports"
  echo

  sudo apt install curl ca-certificates

  sudo add-apt-repository ppa:longsleep/golang-backports

  echo
  echo "added: ppa:longsleep/golang-backports"
fi

if ! command -v go > /dev/null 2>&1; then
  sudo apt install golang-go
fi

echo
echo 'golang installed, version info right below'

go version
