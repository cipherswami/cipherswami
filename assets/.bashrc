###########################################
# File        : .bashrc
# Description : Multi-line prompt bashrc
# Author      : CIPH3R
###########################################

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
PROMPT_COMMAND=""
# STOP CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
  norm_clr='\[\033[0;00m\]' # white
  chrt_clr='\[\033[1;33m\]' # yellow
  venv_clr='\[\033[1;36m\]' # cyan
  info_clr='\[\033[1;32m\]' # green
  wdir_clr='\[\033[1;34m\]' # blue
  pmpt_sym='\$'
  if [ "$EUID" -eq 0 ]; then
    # Root user prompt colors
    info_clr='\[\033[1;31m\]' # red
    pmpt_sym='#'
  fi
  # Override default VENV prompt only for twoline or oneline
  if [[ "$PROMPT_ALTERNATIVE" == "twoline" || "$PROMPT_ALTERNATIVE" == "oneline" ]]; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    export CONDA_CHANGEPS1=false
  fi
  dbchroot='${debian_chroot:+('$chrt_clr'$debian_chroot'$norm_clr')-}'
  condaenv='${CONDA_DEFAULT_ENV:+('$venv_clr'$CONDA_DEFAULT_ENV'$norm_clr')-}'
  virtvenv='${VIRTUAL_ENV:+('$venv_clr'$(basename $VIRTUAL_ENV)'$norm_clr')-}'
  maininfo='('$info_clr'\u@\h'$norm_clr')-['$wdir_clr'\w'$norm_clr']'
  tailinfo=$norm_clr$pmpt_sym' '
  case "$PROMPT_ALTERNATIVE" in
    twoline)
      PS1=$norm_clr$dbchroot$condaenv$virtvenv$maininfo'\n'$tailinfo
      ;;
    oneline)
      PS1=$norm_clr$dbchroot$condaenv$virtvenv$maininfo'-'$tailinfo
      ;;
    backtrack)
      PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      ;;
  esac
  unset norm_clr
  unset chrt_clr
  unset venv_clr
  unset info_clr
  unset wdir_clr
  unset pmpt_sym
  unset dbchroot
  unset condaenv
  unset virtvenv
  unset maininfo
  unset tailinfo
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt* | Eterm | aterm | kterm | gnome* | alacritty)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias diff='diff --color=auto'
  alias ip='ip --color=auto'

  export LESS_TERMCAP_mb=$'\E[1;31m'  # begin blink
  export LESS_TERMCAP_md=$'\E[1;36m'  # begin bold
  export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
  export LESS_TERMCAP_so=$'\E[01;33m' # begin reverse video
  export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
  export LESS_TERMCAP_us=$'\E[1;32m'  # begin underline
  export LESS_TERMCAP_ue=$'\E[0m'     # reset underline
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -Al'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
