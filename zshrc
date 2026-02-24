set -o emacs

autoload -U compinit && compinit
zstyle ':completion:*' menu yes select
zstyle ":completion:*:commands" rehash 1

autoload -U select-word-style
select-word-style bash

bindkey "\e[3~" delete-char

export EDITOR=vim
export LESS="-i -R"
export PATH=$PATH:~/.local/bin
export VCS_PROMPT=git_prompt_info

export HISTFILE=~/.zsh_history
export HISTSIZE=5000
export SAVEHIST=1000000
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

alias cp='cp -vi'
alias grep='grep --color=auto'
alias ls='ls -F'
alias mv='mv -vi'
alias rm='rm -vi'

if [ "$(uname -s)" = "Darwin" ]; then
    export COPYFILE_DISABLE=true
    alias date=gdate
    alias tar=gtar
    alias timeout=gtimeout
fi

base_prompt="%m %30<...<%~ %(!.#.$) "

# _fmt_duration formats a nanosecond duration as a human-readable string,
# matching the output of Go's time.Duration.String().
_fmt_duration() {
    local -i ns=$1
    if (( ns == 0 )); then
        echo "0s"
        return
    fi

    local -i h=$(( ns / 3600000000000 ))
    local -i rem=$(( ns % 3600000000000 ))
    local -i m=$(( rem / 60000000000 ))
    rem=$(( rem % 60000000000 ))
    local -i s=$(( rem / 1000000000 ))
    local -i ms=$(( (rem % 1000000000) / 1000000 ))

    local frac=""
    if (( ms > 0 )); then
        frac=$(printf ".%03d" $ms)
        frac="${frac%0}"
        frac="${frac%0}"
    fi

    if (( h > 0 )); then
        echo "${h}h${m}m${s}${frac}s"
    elif (( m > 0 )); then
        echo "${m}m${s}${frac}s"
    elif (( s > 0 )); then
        echo "${s}${frac}s"
    else
        echo "${ms}ms"
    fi
}

# _parse_ts parses a "sec.nsec" timestamp to nanoseconds, truncated to ms.
_parse_ts() {
    local arg=$1
    local sec="${arg%%.*}"
    local nsec="${arg#*.}"
    local -i ms=$(( 10#${nsec} / 1000000 ))
    echo $(( sec * 1000000000 + ms * 1000000 ))
}

# _elapsed_since prints human-readable duration since a "sec.nsec" timestamp.
_elapsed_since() {
    local -i start=$(_parse_ts "$1")
    local -i end=$(_parse_ts "$(date +%s.%N)")
    _fmt_duration $(( end - start ))
}

function preexec() {
    last_run_time=$(date +%s.%N)
}

function precmd() {
    local retval=0
    (( ${(j[+])pipestatus} )) && retval=${pipestatus[-1]}

    local buf=""

    if [[ -n $last_run_time ]]; then
        local elapsed=$(_elapsed_since $last_run_time)
        case $retval in
            0) buf=$'\u2714'" $elapsed";;
            *) buf=$'\u2718'$(printf " %s [%s]" "$elapsed" "$retval");;
        esac
        buf+=$'\n'
        unset last_run_time
    fi

    if [[ -z $buf && -n $last_vcs_info ]]; then
        custom_prompt="$last_vcs_info $base_prompt"
        return
    fi

    if (( ${+VCS_PROMPT} )); then
        last_vcs_info=$($VCS_PROMPT)
        if [[ -z $last_vcs_info ]]; then
            custom_prompt="$buf$base_prompt"
        else
            custom_prompt="$buf$last_vcs_info $base_prompt"
        fi
    fi
}

function git_prompt_info() {
    local output=""
    if ! output=$(git status --short 2> /dev/null); then
        return
    fi

    local dirty=""
    [[ -n $output ]] && dirty="*"

    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
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

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env

