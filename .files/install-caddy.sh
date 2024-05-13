# shellcheck disable=SC1090,SC2148
source ~/.files/_install_funcs.sh

os="$(get_platform)"
arch="$(get_arch)"
version=2.7.6

repo=https://github.com/caddyserver/caddy

echo 'downloading latest caddy release from github'
echo

version=$(gh_dl $repo "*_${os}_${arch}.deb")
version="${version//v/}"

if [[ "" == "$version" ]]; then
  echo
  echo 'cannot download latest caddy release'

  exit 1
fi

echo
echo 'latest caddy release downloaded'

filename="caddy_${version}_${os}_${arch}.deb"

echo 'installing caddy'
echo

sudo dpkg -i "${filename}"
rm -f "${filename}"

echo
echo 'caddy installed'
