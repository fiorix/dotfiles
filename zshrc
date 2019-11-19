set -o emacs

autoload -U compinit && compinit
zstyle ':completion:*' menu yes select

autoload -U select-word-style
select-word-style bash

export EDITOR=vim
export GOPATH=$HOME/go
export GREP_OPTIONS="--color=auto"
export LESS="-i -R"
export PATH=$PATH:$HOME/bin:$GOPATH/bin
export VCS_PROMPT=git_prompt_info

export HISTFILE=~/.zsh_history
export HISTSIZE=5000
export SAVEHIST=1000000
setopt SHARE_HISTORY

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

base_prompt="%30<...<%~ %(!.#.$) "
custom_prompt=""
last_run_time=""
last_vcs_info=""

function preexec() {
  last_run_time=$(date +%s.%N)
}

function precmd() {
    RETVAL=$pipestatus
    [ $((${(j[+])pipestatus})) -eq 0 ] && RETVAL=0

    local info=""

    if [ ! -z "$last_run_time" ]; then
        local elapsed=$(hmnz duration $last_run_time)
        case $RETVAL in
            0) info=$elapsed;;
            *) info=$(printf "%s [%s]" "$elapsed" "$RETVAL");;
        esac
        unset last_run_time
    fi

    if [ -z "$info" -a ! -z "$last_vcs_info" ]; then
        custom_prompt="$last_vcs_info $base_prompt"
        return;
    fi

    if (( ${+VCS_PROMPT} )); then
        last_vcs_info=$($VCS_PROMPT)
        if [ ! -z "$last_vcs_info" ]; then
            [ -z "$info" ] && info=$last_vcs_info || info="$info $last_vcs_info"
        fi
    fi

    [ -z "$info" ] && custom_prompt="$base_prompt" || custom_prompt="$info $base_prompt"
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

function hg_prompt_info() {
    unset output info parts branch_parts branch

    local output=""
    if ! output="$(hg status 2> /dev/null)"; then
        return
    fi

    local dirty=""
    [ ! -z "$output" ] && dirty="*"

    local info=$(hg log -l1 --template '{author}:{remotenames}:{phabdiff}')
    local parts=(${(@s/:/)info})
    local branch_parts=(${(@s,/,)parts[2]})
    local branch=${branch_parts[-1]}
    [ ! -z "${parts[3]}" ] && [[ "${parts[1]}" =~ "$USER@" ]] && branch=${parts[3]}

    print ${branch}${dirty}
}

setopt PROMPT_SUBST
PROMPT='$custom_prompt'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
