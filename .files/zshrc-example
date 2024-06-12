# shellcheck disable=SC2034,SC1090,SC1091
ZSH=~/.zshd

if [ -f $ZSH/custom/themes/mortalscumbag-ssh.zsh-theme ]; then
  ZSH_THEME="mortalscumbag-ssh"
else
  ZSH_THEME="mortalscumbag"
fi

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=15

export CHEATCOLORS=true

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in $ZSH/plugins/*)
# Custom plugins may be added to $ZSH/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
  colored-man-pages
  colorize
  encode64
  git
  nvm
  npm
  nice-exit-code
)

[[ -s $ZSH/oh-my-zsh.sh ]] && . $ZSH/oh-my-zsh.sh # Load oh-my-zsh, if exists

# Load RVM into a shell session *as a function*
[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm

[[ -s ~/.nvm/nvm.sh ]] && . ~/.nvm/nvm.sh \
  && (nvm use default > /dev/null 2>&1) # Load NVM, if exists

# This loads nvm bash_completion
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME=~/.local/share/pnpm
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Load the shell dotfiles, and then some:
# * ~/path.sh can be used to extend `$PATH`.
# * ~/extra.sh can be used for other settings you don’t want to commit.
for file in ~/.files/{exports,path,prompt,aliases,functions,extra}.sh;
do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file
