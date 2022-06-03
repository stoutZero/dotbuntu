if ! command -v zsh > /dev/null 2>&1 ; then
  if ! [ $(id -u) = 0 ]; then
    echo "We need to install zsh as root. Sudo first please..." >&2
    exit 1
  fi

  sudo apt install -y zsh
fi

git clone https://github.com/bric3/nice-exit-code "${HOME}/.zshd/custom/plugins/nice-exit-code"

if [ $(basename $SHELL) != "zsh" ]; then
  chsh -s $(command -v zsh)
fi
