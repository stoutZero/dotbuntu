#!/usr/bin/env bash

# shellcheck disable=SC1090
source $HOME/.files/functions.sh

# shellcheck disable=SC1090
source $HOME/.files/_install_funcs.sh

if ! command -v zsh > /dev/null 2>&1 ; then
  _run 'sudo apt install -y zsh' 'Installing zsh'
fi

if [ ! -f $HOME/.zshd/README.md ]; then
  echo -n 'Fetching git submodules (.zshd)'
  [ -f $HOME/.zshd ] && rm -rf $HOME/.zshd

  git submodule init &> /dev/null
  git submodule update &> /dev/null

  _success 'DONE'
fi

if [ ! -d $HOME/.zshd/custom/plugins/nice-exit-code ]; then
  echo -n 'Cloning https://github.com/bric3/nice-exit-code into $HOME/.zshd/custom/plugins/nice-exit-code ... '

  git clone https://github.com/bric3/nice-exit-code \
    $HOME/.zshd/custom/plugins/nice-exit-code &> /dev/null
  
  _success 'DONE'
fi

if [ ! -d $HOME/.zshd/custom/plugins/fzf-tab ]; then
  echo -n 'Cloning https://github.com/Aloxaf/fzf-tab into $HOME/.zshd/custom/plugins/fzf-tab ... '

  git clone https://github.com/Aloxaf/fzf-tab \
    $HOME/.zshd/custom/plugins/fzf-tab &> /dev/null

  _success 'DONE'
fi

if [[ "$(basename "$SHELL")" != "zsh" ]]; then
  _run "chsh -s $(command -v zsh)" 'Changing shell to zsh'
fi

if [ ! -f $HOME/.zshd/custom/themes/mortalscumbag-ssh.zsh-theme ] \
  && [ -f $HOME/.files/mortalscumbag-ssh.zsh-theme ]; then
  _run "cp -an $HOME/.files/mortalscumbag-ssh.zsh-theme $HOME/.zshd/custom/themes/" \
    'Setting mortalscumbag-ssh as zsh theme'
fi

if [ ! -f $HOME/.gitconfig ]; then
  cp $HOME/.files/_gitconfig $HOME/.gitconfig
fi

if [ ! -f $HOME/.zshd_plugins ]; then
  cp $HOME/.files/.zshd_plugins $HOME/
fi

if [ ! -f $HOME/.zshrc ]; then
  cp $HOME/.files/.zshrc $HOME/
fi

mkdir -p $HOME/tmp

[ ! -f $HOME/.github-token ] && touch $HOME/.github-token
[ ! -f $HOME/.discord.url ] && touch $HOME/.discord.url
