set -o emacs

autoload -U compinit && compinit
zstyle ':completion:*' menu yes select

export EDITOR=vim
export GOPATH=$HOME/go
export GREP_OPTIONS="--color=auto"
export HISTSIZE=5000
export LESS="-i -R"
export PATH=$PATH:$HOME/bin:$GOPATH/bin
export SAVEHIST=1000000
export VCS_PROMPT=git_prompt_info

alias cp='cp -vi'
alias ls='ls -F'
alias mv='mv -vi'
alias rm='rm -vi'
alias scpresume="rsync --partial --progress --rsh=ssh"
alias ssh='ssh -v'

if [ "$(uname -s)" = "Darwin" ]; then
    export COPYFILE_DISABLE=true
    alias date=gdate
    alias tar=gtar
fi

custom_rprompt=""
last_run_time=""
last_vcs_info=""

function preexec() {
  last_run_time=$(date +%s.%N)
}

function precmd() {
    RETVAL=$?
    local info=""

    if [ ! -z "$last_run_time" ]; then
        local elapsed=$(hmnz duration $last_run_time)
        case $RETVAL in
            0) info=$elapsed;;
            *) info=$(printf "%s \u2612 %d" "$elapsed" "$RETVAL");;
        esac
        unset last_run_time
    fi

    if [ -z "$info" -a ! -z "$last_vcs_info" ]; then
        custom_rprompt=$last_vcs_info
        return;
    fi

    if (( ${+VCS_PROMPT} )); then
        last_vcs_info=$($VCS_PROMPT)
        [ -z "$info" ] && info=$last_vcs_info || info="$info $last_vcs_info"
    fi

    custom_rprompt=$info
}

function git_prompt_info() {
    local output=""
    if ! output=$(git status --short 2> /dev/null); then
        return
    fi

    local dirty=""
    [ ! -z "$output" ] && dirty="*"

    local branch=$(git branch | grep \* | cut -d' ' -f2)
    print ${branch}${dirty}
}

setopt PROMPT_SUBST
PROMPT='%30<...<%~ %(!.#.$) '
RPROMPT='$custom_rprompt'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
