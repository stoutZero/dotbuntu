#!/usr/bin/env zsh

# shellcheck disable=SC1090
source ~/.files/functions.sh

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

_info 'installing: gh-cli from github as root'

repo="https://github.com/cli/cli"

arc="$(get_arch)"
platform="$(get_platform)"
version="$(gh_latest "$repo" | tr -d 'v')"

$filename="gh_${version}_${platform}_${arc}.deb"

url="${repo}/releases/download/v${version}/$filename"

wget -qO $url > /dev/null 2>&1

sudo dpkg -i "$filename"

_info 'installed: gh-cli from github as root'
