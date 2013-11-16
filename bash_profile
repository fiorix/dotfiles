# Aliases
alias ls='ls -GF'
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'
alias ssh='ssh -v'
alias scpresume="rsync --partial --progress --rsh=ssh"

# Shell settings
export EDITOR=vim
export GREP_OPTIONS="--color=auto"
export HISTSIZE=8000
export LESS="-i -R"
export COPYFILE_DISABLE=true # Prevent OSX's tar from creating ._ files

# Go
export GOROOT=/opt/go
export GOPATH=~/go

# Python
export PYTHONSTARTUP=~/.pyrc

# Freegeoip
function geoip_curl_xml { curl -D - https://freegeoip.net/xml/$1; }
alias geoip=geoip_curl_xml

# Path
export PATH=$GOROOT/bin:$GOPATH/bin:/bin:/usr/local/bin:/usr/local/sbin:$PATH

fortune -o
