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

if [ "$(\ls -1 $HOME/.zcompdump* | wc -l | tr -d ' ')" -gt 1 ]; then
  rm -f $HOME/.zcompdump*
fi

[[ -s ~/.nvm/nvm.sh ]] && source ~/.nvm/nvm.sh \
  && (nvm use default > /dev/null 2>&1) # Load NVM, if exists

# Which plugins would you like to load? (plugins can be found in $ZSH/plugins/*)
# Custom plugins may be added to $ZSH/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
typeset -a plugins
plugins=("${(@f)"$(<.zshd_plugins)"}")

## these two fzf stuff must be loaded after compinit, but before plugins
# completions
[[ -f $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh

# bash and zsh key bindings for Git objects
[[ -s $HOME/.fzf-git.sh/fzf-git.sh ]] && source $HOME/.fzf-git.sh/fzf-git.sh

# it's highly discouraged to run both firewalld & ufw in the same system
if command -v firewall-cmd &>/dev/null && [[ ! -x $(command -v ufw 2>/dev/null) ]]; then
  plugins+=(firewalld)
fi

if command -v ufw &>/dev/null && [[ ! -x $(command -v firewall-cmd 2>/dev/null) ]]; then
  plugins+=(ufw)
fi

if docker compose &>/dev/null; then
  plugins+=(docker-compose)
fi

# Load oh-my-zsh, if exists
[[ -s $ZSH/oh-my-zsh.sh ]] && . $ZSH/oh-my-zsh.sh

# This loads nvm bash_completion
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

## this must be run after compinit, which inside oh-my-zsh.sh
if command -v uv &>/dev/null; then
  eval "$(uv generate-shell-completion zsh)"
  eval "$(uvx --generate-shell-completion zsh)"
fi

# Do menu-driven completion.
zstyle ':completion:*' menu select

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'show-group' yes
zstyle ':omz:plugins:eza' 'size-prefix' binary

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [ -n "${ZSH_DEBUGRC+1}" ]; then
  zprof
fi

# Load the shell dotfiles, and then some:
# * ~/path.sh can be used to extend `$PATH`.
# * ~/extra.sh can be used for other settings you don’t want to commit.
for file in ~/.files/{exports,path,prompt,aliases,functions,extra}.sh;
do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file

[ -s $HOME/.local/bin/env ] && source $HOME/.local/bin/env

if [ -s $HOME/.local/bin ]; then
  export -U PATH="$HOME/.local/bin:$PATH"
fi

if [ -s $HOME/.local/bin ]; then
  export -U PATH="$HOME/.local/bin:$PATH"
fi
