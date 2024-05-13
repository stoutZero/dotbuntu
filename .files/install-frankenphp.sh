# shellcheck disable=SC1090,SC2148
source ~/.files/_install_funcs.sh

os="$(get_platform)"
hw="$(get_hw)"

repo=https://github.com/dunglas/frankenphp
filename="frankenphp-${os}-${hw}"

gh_dl "$repo" "$filename"

if [ -f "$filename" ]; then
  sudo mv "$filename" /usr/local/bin/
fi
