#!/bin/bash
# vi: sw=4 ts=4 et ai

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# ---------------------- local utility functions ---------------------

_have() { type "$1" &>/dev/null; }
_source_if() { [[ -r "$1" ]] && source "$1"; }

# ----------------------- environment variables ----------------------

export LANG="en_US.UTF-8"
export USER="${USER:-$(whoami)}"
export TZ="Europe/Athens"
export PYTHONDONTWRITEBYTECODE=1

[[ -d /.vim/spell ]] && export VIMSPELL=("$HOME/.vim/spell/*.add")

# ------------------------------ history -----------------------------

# don't put duplicate lines or lines starting with space in the history & erase past duplicate lines.
export HISTCONTROL='ignoreboth:erasedups' 
export HISTSIZE=-1      # infinite size to remember     (1000000)
export HISTFILESIZE=-1  # infinite size of the histfile (2000000)

shopt -s histappend

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# ------------------------ bash shell options ------------------------

# shopt is for BASHOPTS, set is for SHELLOPTS

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize 
shopt -s expand_aliases
shopt -s globstar
shopt -s dotglob

# -------------------------- stty annoyances -------------------------

stty -ixon # disable control-s/control-q tty flow control

# -------------------------------- gpg -------------------------------

GPG_TTY=$(tty)
export GPG_TTY

# ------------------------------- pager ------------------------------

if [[ -x /usr/bin/lesspipe ]]; then
    export LESSOPEN="| /usr/bin/lesspipe %s"
    export LESSCLOSE="/usr/bin/lesspipe %s %s"
fi

# ----------------------------- dircolors ----------------------------

if _have dircolors; then
    if [[ -r "$HOME/.dircolors" ]]; then
        eval "$(dircolors -b "$HOME/.dircolors")"
    else
        eval "$(dircolors -b)"
    fi
fi

# ------------------------------- path -------------------------------

pathappend() {
    declare arg
    for arg in "$@"; do
        test -d "$arg" || continue
        PATH=${PATH//":$arg:"/:}
        PATH=${PATH/#"$arg:"/}
        PATH=${PATH/%":$arg"/}
        export PATH="${PATH:+"$PATH:"}$arg"
    done
} && export -f pathappend

pathprepend() {
    for arg in "$@"; do
        test -d "$arg" || continue
        PATH=${PATH//:"$arg:"/:}
        PATH=${PATH/#"$arg:"/}
        PATH=${PATH/%":$arg"/}
        export PATH="$arg${PATH:+":${PATH}"}"
    done
} && export -f pathprepend

# remember last arg will be first in path
pathprepend \
    "$HOME/.local/bin" \
    "$HOME/.local/go/bin" \
    /opt/homebrew/bin

pathappend \
    '/mnt/c/Windows' \
    /mingw64/bin \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/sbin \
    /usr/bin \
    /snap/bin \
    /sbin \
    /bin

# ------------------------------ prompt ------------------------------

__ps1() {

    # r -> RED
    # h -> hostname color
    # u -> username color
    # p -> Pound/Dollar color
    # w -> cwd color
    # b -> git branch color
    # x -> stops all formatting+colors
    # g -> EndColor
    local P='$' PROMPT_AT='@' dir='\w' \
        r='\[\e[31m\]' h='\[\e[32m\]' \
        u='\[\e[32m\]' p='' w='\[\e[34m\]' \
        b='\[\e[32m\]' x='\[\e[0m\]' \
        g="\[\033[38;2;90;82;76m\]" \
        B

    [[ $EUID == 0 ]] && P='#' && u=$r && p=$u # root
    # Short cwd path
    # local dir="${PWD##*/}"
    # [[ $PWD = / ]] && dir=/
    # [[ $PWD = "$HOME" ]] && dir='~'

    if _have '__git_ps1';then
        B=$(__git_ps1 '%s')
    elif _have 'git'; then
        B=$(git branch --show-current 2>/dev/null)
    else
        B='' # no git branch detection
    fi
    [[ $dir = "$B" ]] && B=.
    [[ $B == master || $B == main ]] && b="$r"
    [[ -n "$B" ]] && B="$g($b$B$g) "

    # Pattern is:
    # "($B) $USER$PROMPT_AT$(hostname):$dir\$ "

    # Classic
    PS1="$B$u\u$g$PROMPT_AT$h\h$g:$w$dir$g$p$P$x "
    # Bold
    PS1="\[\e[1m\]${PS1}"
}
PROMPT_COMMAND="__ps1"


 
# ------------------------------ aliases ----------------------------- 

# Universal aliases (private/local ones in .bash_aliases)

unalias -a
alias ls='ls -h --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias ip='ip -c'
alias chmox='chmod +x'
alias diff='diff --color'

_source_if "$HOME/.bash_aliases"

# ----------------------------- keyboard -----------------------------

# only works if you have X and are using graphic Linux desktop

_have setxkbmap && test -n "$DISPLAY" &&
    setxkbmap -option caps:escape &>/dev/null 


# ----------------------------- editor -------------------------------
set-editor() {
    export EDITOR="$1"
    export VISUAL="$1"
    export GIT_EDITOR="$1"
    alias vi="\$EDITOR"
}
_have "vi" && set-editor vi
_have "vim" && set-editor vi

# ------------- source external dependencies / completion ------------

# for mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew_prefix="$(brew --prefix)"
    if [[ -r "$brew_prefix/etc/profile.d/bash_completion.sh" ]]; then
        source "$brew_prefix/etc/profile.d/bash_completion.sh"
    fi
fi


# TODO: maybe unnecessary since most distros have this in /etc/bash.bashrc
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# fzf bash-completion plugin (debian) 
# TODO: check if we can enable without sourcing it explicitly
_source_if "/usr/share/bash-completion/completions/fzf"

# ------------------  PATH-dependant config --------------------------
_have go && export GOPATH="$HOME/.local/go"
_have go && export GOBIN="$HOME/.local/bin"

# ---------------- local/private configuration -----------------------
_source_if "$HOME/.bash_private"
