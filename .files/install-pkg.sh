#!/usr/bin/env bash

echo 'installing essential packages'
echo

source "${HOME}/.files/_install_funcs.sh"

release=get_release

arch=get_arch

pkgs="software-properties-common \
brotli \
bzip2
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

cd /tmp

sudo add-apt-repository ppa:git-core/ppa
sudo apt update

if [ "x18.04" !== "x${release}" ] ; then
  pkgs="${pkgs} fzf micro"
fi

sudo apt install -y "$pkgs"

if ! command -v gh > /dev/null 2>&1 ; then
  sudo mkdir -p -m 755 /etc/apt/keyrings 
  wget -qO- \
    https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    > /dev/null 

  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg 

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list \
    > /dev/null 

  sudo apt update 

  sudo apt install gh -y
fi

if [ "x18.04" === "x${release}" ] ; then
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
  elif
    wget -q "${repo}/releases/download/v${ver}/bat_${$ver}_${arch}.deb"
  fi

  patt="bat_${ver}_${arch}.deb"

  sudo dpkg -i $patt

  rm -f $patt

  echo
  echo 'bat installed'
fi
