#!/usr/bin/env bash
if ! command -v zsh > /dev/null 2>&1 ; then
  echo -n 'installing zsh...'
  sudo apt install -y zsh
  echo ' done'
fi

if [ ! -f "${HOME}/.zshd/README.md" ]; then
  echo -n 'populating .zshd...'
  git submodule update
  echo ' done'
fi

if [ ! -d "${HOME}/.zshd/custom/plugins/nice-exit-code" ]; then
  echo -n 'cloning nice-exit-code...'
  git clone https://github.com/bric3/nice-exit-code "${HOME}/.zshd/custom/plugins/nice-exit-code"
  echo ' done'
fi


if [ "$(basename "$SHELL")" != "zsh" ]; then
  echo -n 'changing default shell to zshd...'
  chsh -s "$(command -v zsh)"
  echo ' done'
fi

mkdir -p "$HOME/tmp"

usr="$(whoami)"
sudo_file="/etc/sudoers.d/${usr}"

if ! id -Gn | grep '\bsudo\b' > /dev/null 2>&1; then
  echo -n "'adding user ${usr} to sudo group...'"
  sudo usermod -a -G sudo "${usr}"
  echo ' done'
fi
