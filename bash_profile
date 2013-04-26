# fiorix's .bash_profile

alias ls='ls -GF'
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'
alias ssh='ssh -v'
alias scpresume="rsync --partial --progress --rsh=ssh"

function geoip_curl_xml { curl -D - http://freegeoip.net/xml/$1; }
alias geoip=geoip_curl_xml

export EDITOR=vim
export GREP_OPTIONS="--color=auto"
export HISTSIZE=8000
export LESS="-i -R"
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PYTHONSTARTUP=~/.pyrc

# go
export GOROOT=/usr/local/Cellar/go/1.0.3/
export GOPATH=~/go

# Avoid OSX's tar to add dot underscore (._) files when creating archives.
export COPYFILE_DISABLE=true

#fortune -o
