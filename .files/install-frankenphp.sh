#!/usr/bin/env bash

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

os="$(get_platform)"
hw="$(get_hw)"

repo=https://github.com/dunglas/frankenphp
filename="frankenphp-${os}-${hw}"

gh_download_latest "$repo" "$filename"

if [ -f "$filename" ]; then
  sudo mv "$filename" /usr/local/bin/
fi