#!/usr/bin/env bash
if ! command -v zsh > /dev/null 2>&1 ; then
  echo 'installing zsh'
  echo
  sudo apt install -y zsh
  echo
  echo 'zsh installed'
fi

if [ ! -f "${HOME}/.zshd/README.md" ]; then
  echo 'fetching git submodules (.zshd)'
  echo

  [ -f "${HOME}/.zshd" ] && rm -rf "${HOME}/.zshd"

  git submodule init
  git submodule update

  echo
  echo 'git submodules fetched'
fi

if [ ! -d "${HOME}/.zshd/custom/plugins/nice-exit-code" ]; then
  echo 'cloning nice-exit-code'
  echo
  git clone https://github.com/bric3/nice-exit-code \
    "${HOME}/.zshd/custom/plugins/nice-exit-code"
  echo
  echo 'nice-exit-code cloned'
fi


if [ "$(basename "$SHELL")" != "zsh" ]; then
  echo 'changing default shell to zshd'
  echo
  chsh -s "$(command -v zsh)"
  echo
  echo 'default shell changed'
fi

mkdir -p "$HOME/tmp"

usr="$(whoami)"

if [ ! -f "/etc/sudoers.d/${usr}" ]; then
  echo "adding user ${usr} to sudo"

  echo "${usr} ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/${usr}"

  echo "user ${usr} added to sudo"
fi

if [ ! -f "${HOME}/.github-token" ]; then
  touch "${HOME}/.github-token"
fi
