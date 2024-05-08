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

if ! id -Gn | grep '\bsudo\b' > /dev/null 2>&1; then
  echo "'adding user ${usr} to sudo group...'"
  sudo usermod -a -G sudo "${usr}"
  echo ' done'
fi
