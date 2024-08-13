# shellcheck disable=SC2148
# SC2148: Tips

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....="cd ../../../.."

alias a='php artisan'

# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"

alias c='composer '
alias cela='clear; els -l -a -h '
alias cla='clear; ls -lash '
alias clone='git clone '

alias d='docker '
alias dc='docker compose '
alias dcx='docker compose exec '

alias dfh='df -h '
alias duh='du -h '

alias edit='$EDITOR'

alias ela='els -l -a -h '
alias empty='truncate -s0 '

if ! command -v frankenphp > /dev/null 2>&1 ; then
	alias fart='frankenphp php-cli ./artisan'
fi

alias fire='dig +short -t txt istheinternetonfire.com'

alias g='\git '
alias gaa='\git add .'
alias gcm='\git commit -m '
alias grep='grep -i --color=auto '
alias gp='\git push'

alias h="fc -l 1"

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

alias history="history"
alias hs='fc -l 1 | grep --color=auto'
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

alias j="jobs"

alias k9='kill -9 '

alias lla='ls -lash '
alias lns='ln -s'

alias mkdir='mkdir -p '
alias mv='mv '

alias myip='wget -O - -q ipv4.icanhazip.com'
alias myip6='wget -O - -q ipv6.icanhazip.com'

alias ngd='sudo nginx -s stop'
alias ngr='sudo nginx -s reload'
alias ngt='sudo nginx -t'

alias ne='node -e '
alias nls='npm ls '
alias nn='nano '

alias pgf='pgrep -f '
alias po='popd '
alias psx='ps aux '

# Reload the shell (i.e. invoke as a login shell)
alias relogin='exec $SHELL -l'

alias rmf='rm -f '

alias scl='screen -ls '
alias scr='screen -r '

alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias ssh='ssh -o TCPKeepAlive=yes '
alias sudo='nocorrect sudo '

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

alias tlf='tail -f '
alias tln='tail -n '

# URL-encode strings
alias urlencode='python3 -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Get week number
alias week='date +%V'

alias wgnc='wget --no-check-certificate '

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	# shellcheck disable=SC2139,SC2140
	alias "$method"="lwp-request -m '$method'"
done
