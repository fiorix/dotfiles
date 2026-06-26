set -o emacs

[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"

if [ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

bind '"\e[3~": delete-char'

if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export EDITOR=vim
export LESS="-i -R"
export PATH=$PATH:~/.local/bin
export VCS_PROMPT=git_prompt_info

export HISTFILE=~/.bash_history
export HISTSIZE=5000
export HISTFILESIZE=1000000
export HISTCONTROL=ignorespace:erasedups
shopt -s histappend

alias cp='cp -vi'
alias grep='grep --color=auto'
alias ls='ls -F'
alias mv='mv -vi'
alias rm='rm -vi'

if [ "$(uname -s)" = "Darwin" ]; then
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export COPYFILE_DISABLE=true
    alias date=gdate
    alias tar=gtar
    alias timeout=gtimeout
    alias sdme='limactl shell default sudo sdme'
fi

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

# Preexec via DEBUG trap: capture timestamp of first command per prompt cycle.
_preexec_ran=1
trap '[ "$_preexec_ran" = "0" ] && _preexec_ran=1 && last_run_time=$(date +%s.%N)' DEBUG

_precmd() {
    local retval=$?
    local _pipes=("${PIPESTATUS[@]}")

    local sum=0
    for p in "${_pipes[@]}"; do
        sum=$((sum + p))
    done
    if [ "$sum" -ne 0 ]; then
        retval=${_pipes[${#_pipes[@]}-1]}
    fi

    # Detect if a real command was run by checking history number.
    local cur_hist
    cur_hist=$(HISTTIMEFORMAT='' builtin history 1 | awk '{print $1}')

    local buf=""

    if [ -n "${last_run_time:-}" ] && [ "${cur_hist:-}" != "${_last_hist:-}" ]; then
        local elapsed=$(_elapsed_since "$last_run_time")
        if [ "$retval" -eq 0 ]; then
            buf=$(printf '\xe2\x9c\x94 %s' "$elapsed")
        else
            buf=$(printf '\xe2\x9c\x98 %s [%s]' "$elapsed" "$retval")
        fi
        buf="$buf"$'\n'
    fi
    unset last_run_time
    _last_hist=$cur_hist

    local vcs_info=""
    if [ -n "${VCS_PROMPT:-}" ]; then
        if [ -n "$buf" ] || [ -z "${last_vcs_info:-}" ]; then
            last_vcs_info=$($VCS_PROMPT)
        fi
    fi

    local dir="$PWD"
    case "$dir" in
        "$HOME") dir="~";;
        "$HOME"/*) dir="~${dir#$HOME}";;
    esac
    if [ "${#dir}" -gt 30 ]; then
        dir="...${dir:$(( ${#dir} - 27 ))}"
    fi
    local host=$(hostname -s)
    local suffix='$'
    [ "$(id -u)" -eq 0 ] && suffix='#'

    if [ -n "${last_vcs_info:-}" ]; then
        PS1="${buf}${last_vcs_info} ${host} ${dir} ${suffix} "
    else
        PS1="${buf}${host} ${dir} ${suffix} "
    fi

    _preexec_ran=0
}

PROMPT_COMMAND=_precmd

git_prompt_info() {
    local output=""
    if ! output=$(git status --short 2>/dev/null); then
        return
    fi

    local dirty=""
    [ -n "$output" ] && dirty="*"

    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    echo "${branch}${dirty}"
}

[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
