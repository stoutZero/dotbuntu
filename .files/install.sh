#!/usr/bin/env bash
if ! command -v zsh > /dev/null 2>&1 ; then
  echo 'installing zsh'
  echo
  sudo apt install -y zsh
  echo
  echo 'zsh installed'
fi

if [ ! -f ~/.zshd/README.md ]; then
  echo 'fetching git submodules (.zshd)'
  echo

  [ -f ~/.zshd ] && rm -rf ~/.zshd

  git submodule init
  git submodule update

  echo
  echo 'git submodules fetched'
fi

if [ ! -d ~/.zshd/custom/plugins/nice-exit-code ]; then
  echo 'cloning nice-exit-code'
  echo
  git clone https://github.com/bric3/nice-exit-code \
    ~/.zshd/custom/plugins/nice-exit-code
  echo
  echo 'nice-exit-code cloned'
fi


if [[ "$(basename "$SHELL")" != "zsh" ]]; then
  echo 'changing default shell to zshd'
  echo
  chsh -s "$(command -v zsh)"
  echo
  echo 'default shell changed'
fi

if [ ! -f ~/.zshd/custom/themes/mortalscumbag-ssh.zsh-theme ] \
  && [ -f ~/.files/mortalscumbag-ssh.zsh-theme.sh ]; then
  cp -an ~/.files/mortalscumbag-ssh.zsh-theme.sh \
    ~/.zshd/custom/themes/
fi

if [ ! -f ~/.gitconfig ]; then
  cp ~/.files/gitconfig-example ~/.gitconfig
fi

if [ ! -f ~/.zshrc ]; then
  cp ~/.files/zshrc-example ~/.zshrc
fi

mkdir -p ~/tmp

[ ! -f ~/.github-token ] && touch ~/.github-token

[ ! -f ~/.discord.url ] && touch ~/.discord.url
