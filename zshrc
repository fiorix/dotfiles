export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
source $ZSH/oh-my-zsh.sh

# User configuration

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export COPYFILE_DISABLE=true # Otherwise OSX tar will create ._ files
export EDITOR=vim
export GOPATH=$HOME/go
export GREP_OPTIONS="--color=auto"
export HISTSIZE=5000
export LESS="-i -R"
export PATH=$PATH:$GOPATH/bin
export SAVEHIST=1000000

alias cp='cp -vi'
alias date=gdate
alias ls='ls -F'
alias mv='mv -vi'
alias rm='rm -vi'
alias scpresume="rsync --partial --progress --rsh=ssh"
alias ssh='ssh -v'
alias tar=gtar

custom_rprompt=""
last_exec_time=""

function preexec() {
  last_exec_time=$(gdate +%s.%N)
}

function precmd() {
    RETVAL=$?
    local info=""

    if [ ! -z "$last_exec_time" ]; then
        local elapsed=$(hmnz duration $last_exec_time)
        case $RETVAL in
            0) info=$elapsed;;
            *) info=$(printf "%s \u2612 %d" "$elapsed" "$RETVAL");;
        esac
        unset last_exec_time
    fi

    local git_info=$(git_prompt_info)
    if [ ! -z "$git_info" ]; then
        [ -z "$info" ] && info=$git_info || info="$info $git_info"
    fi

    custom_rprompt=$info
}

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

PROMPT='%30<...<%~ %(!.#.$) '
RPROMPT='$custom_rprompt'

export custom_prompt # allows to unset/set RPROMPT at will.
