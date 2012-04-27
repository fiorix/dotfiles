# fiorix's .bash_profile

# Aliases
alias ls='ls -GF'
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'

# Path
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Editor
export EDITOR=vim

# Fancy highlighting for grep
export GREP_OPTIONS="--color=auto"

# Python
export PYTHONSTARTUP=~/.pyrc

# Bash history
export HISTSIZE=8000

# Avoid OSX's tar to add dot underscore (._) files when creating archives.
export COPYFILE_DISABLE=true

# Geoip
function geoip_curl_xml { curl -D - http://freegeoip.net/xml/$1; }
alias geoip=geoip_curl_xml

# Good old fortune.
fortune -o
