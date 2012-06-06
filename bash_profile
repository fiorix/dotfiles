# fiorix's .bash_profile

alias ls='ls -GF'
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'
alias scpresume="rsync --partial --progress --rsh=ssh"

function geoip_curl_xml { curl -D - http://freegeoip.net/xml/$1; }
alias geoip=geoip_curl_xml

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export EDITOR=vim
export GREP_OPTIONS="--color=auto"
export PYTHONSTARTUP=~/.pyrc
export HISTSIZE=8000

# Avoid OSX's tar to add dot underscore (._) files when creating archives.
export COPYFILE_DISABLE=true

#fortune -o
