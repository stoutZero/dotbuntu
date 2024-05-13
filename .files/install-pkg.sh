#!/usr/bin/env bash

echo 'installing essential packages'
echo

# shellcheck disable=SC1090
source ~/.files/_install_funcs.sh

release="$(get_release)"
release_name="$(get_release_name)"

arch="$(get_arch)"

pkgs="software-properties-common \
brotli \
bzip2 \
curl \
dnsutils \
git \
gzip \
jq \
htop \
nano \
traceroute \
unhide \
wget \
zip \
zstd"

cd /tmp || exit

if [ ! -f "/etc/apt/sources.list.d/git-core-ubuntu-ppa-${release_name}.list" ]
then
  sudo add-apt-repository ppa:git-core/ppa
  sudo apt update
fi

if [ "18.04" != "${release}" ] ; then
  pkgs="${pkgs} fzf micro"
fi

pkg="$(< "$pkgs" tr -d '\n')"

echo "installing:  ${pkgs}"
sudo apt install -y "$pkgs"

if ! command -v gh > /dev/null 2>&1 ; then
  install_keyring

  wget -qO- \
    https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    > /dev/null

  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

  echo "deb [arch=${arch} signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list \
    > /dev/null 

  sudo apt update 

  sudo apt install gh -y
fi

if [ "18.04" == "${release}" ] ; then
  echo 'installing micro & fzf'
  echo

  curl https://getmic.ro | bash

  sudo mv ./micro /usr/local/bin
  sudo chown root: /usr/local/bin/micro

  wget -q https://github.com/junegunn/fzf/releases/download/0.52.0/fzf-0.52.0-linux_"${arch}".tar.gz

  tar xzf fzf-0.52.0-linux_"${arch}".tar.gz

  sudo mv ./fzf /usr/local/bin
  sudo chown root: /usr/local/bin/fzf

  echo
  echo 'micro & fzf installed'
fi

echo
echo 'essential packages installed'

if ! command -v bat > /dev/null 2>&1 ; then
  echo 'installing bat'
  echo

  ver="0.24.0"
  repo=https://github.com/sharkdp/bat
  patt="bat_${ver}_${arch}.deb"

  if ! command -v gh > /dev/null 2>&1 ; then
    ver=$(gh_download_latest $repo "*_${arch}.deb")
  else
    wget -q "${repo}/releases/download/v${ver}/${patt}"
  fi

  patt="bat_${ver}_${arch}.deb"

  sudo dpkg -i "$patt"

  rm -f "$patt"

  echo
  echo 'bat installed'
fi
