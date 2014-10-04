# Aliases
alias ls='ls -GF'
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'
alias ssh='ssh -v'
alias scpresume="rsync --partial --progress --rsh=ssh"
alias vi=/usr/local/bin/vim
alias vim=/usr/local/bin/vim

# Shell settings
export EDITOR=vim
export GREP_OPTIONS="--color=auto"
export HISTSIZE=8000
export LESS="-i -R"
export COPYFILE_DISABLE=true # Otherwise OSX tar will create ._ files

# Dev
export GOROOT=/opt/go
export GOPATH=$HOME
export PYTHONSTARTUP=~/.pyrc

# Freegeoip
function geoip_curl_xml { curl -i http://freegeoip.net/json/$1; }
alias geoip=geoip_curl_xml

# Path
export PATH=$PATH:/usr/local/bin:/usr/local/sbin:$GOROOT/bin:$GOPATH/bin

# Git completion
[ -r ~/.git-completion.bash ] && . ~/.git-completion.bash

PS1='\W \$ '

#fortune -o
