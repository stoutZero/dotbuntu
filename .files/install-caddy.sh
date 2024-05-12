#!/usr/bin/env bash

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

os=get_platform
arch=get_arch
version=2.7.6

repo=https://github.com/caddyserver/caddy

version=$(gh_download_latest $repo "*_${os}_${arch}.deb")
version="${version//v/}"

filename="caddy_${version}_${os}_${arch}.deb"

gh release download \
  -R "${repo}" \
  -p "${filename}" \
  "v${version}"

sudo dpkg -i "${filename}"
rm -f "${filename}"
