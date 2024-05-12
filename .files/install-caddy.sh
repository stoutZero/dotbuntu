#!/usr/bin/env bash

source ~/.files/_install_funcs.sh

os=get_platform
arch=get_arch
version=2.7.6

version=$(gh_download_latest $repo "*_${os}_${arch}.deb")
version=$(echo $version | sed -e 's/v//g')

filename="caddy_${version}_${os}_${arch}.deb"

gh release download \
  -R https://github.com/caddyserver/caddy \
  -p "${filename}" \
  "v${version}"

sudo dpkg -i "${filename}"
rm -f "${filename}"
