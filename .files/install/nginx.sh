#!/usr/bin/env zsh

echo "adding ondrej's ppa"
echo

sudo add-apt-repository ppa:ondrej/nginx-mainline

echo
echo "ondrej's ppa added"

echo 'installing nginx via apt'
echo

sudo apt install -y nginx-full

echo
echo 'nginx installed via apt'
