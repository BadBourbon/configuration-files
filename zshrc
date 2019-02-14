# -----------------------------
# Prompt + Title
# -----------------------------

bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# colors
export TERM='xterm-256color'
autoload -U colors && colors

for color in red green yellow blue magenta cyan black white; do
    eval $color='%{$fg_no_bold[${color}]%}'
    #eval ${color}_bold='%{$fg_bold[${color}]%}'
done

reset="%{$reset_color%}"

# Add ssh-agent on login
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s` &> /dev/null
  ssh-add &> /dev/null
fi

# check if we are on SSH or not
if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
  host="${black}[${blue}%m${black}] " #SSH
else
  unset host # no SSH
fi
# git
setopt prompt_subst
autoload -U add-zsh-hook
autoload -Uz vcs_info

add-zsh-hook precmd vcs_info

# root / user
if [ "$EUID" -eq 0 ]; then
  bracket_o="${red}["
  bracket_c="${red}]"
else
  bracket_o="${black}["
  bracket_c="${black}]"
fi

PROMPT="${host}${bracket_o}${magenta}%2~${bracket_c}${reset} "
RPROMPT='$vcs_info_msg_0_'"$reset"

# title
case $TERM in
  xterm*|rxvt*|screen*)
    precmd() { print -Pn "\e]0;%m:%~\a" }
    preexec () { print -Pn "\e]0;$1\a" }
  ;;
esac
#-----------------------------
#Misc
#-----------------------------

perms() {
  if [[ -z "$1" ]]; then
    find .    -type d -print0 | xargs -0 chmod 700
    find .    -type f -print0 | xargs -0 chmod 600
  else
    find "$*" -type d -print0 | xargs -0 chmod 700
    find "$*" -type f -print0 | xargs -0 chmod 600
  fi
}
permsg() {
  if [[ -z "$1" ]]; then
    find .    -type d -print0 | xargs -0 chmod 770
    find .    -type f -print0 | xargs -0 chmod 660
  else
    find "$*" -type d -print0 | xargs -0 chmod 770
    find "$*" -type f -print0 | xargs -0 chmod 660
  fi
}

# zsh
setopt auto_cd

setopt extended_glob

setopt interactive_comments

# better word separators (ctrl-w will become much more useful)
WORDCHARS=''

# editor
export EDITOR="vim"
export BROWSER="Chomium"

# grep colors
#export GREP_COLORS="mt=33"
#export GREP_OPTIONS='--color=auto'

# disable speaker
unsetopt beep


# -----------------------------
# History
# -----------------------------

HISTFILE=$HOME/.zsh_history
HISTSIZE=9999
SAVEHIST=9999

setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
# -----------------------------
# Completion
# -----------------------------

# Enable zsh auto-completion
autoload -U compinit && compinit

_comp_options+=(globdots) # completion fot dotfiles

zstyle ':completion:*' menu select
# -----------------------------
# Bindings
# -----------------------------

# emacs style
bindkey -e
bindkey "\e[3~" delete-char #delete
bindkey "^[[H"  beginning-of-line #home
bindkey "^[[F"  end-of-line       #end
bindkey "^[[A"  history-beginning-search-backward #up
bindkey "^[[B"  history-beginning-search-forward  #down
bindkey '^[[1;5D'   backward-word #ctrl+left
bindkey '^[[1;5C'   forward-word  #ctrl+right
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
# ssht
ssht () { ssh -t "$1" 'tmux attach || tmux new' }

# history
h() {
  if [[ -z "$1" ]]; then
    history
  else
    history 0 | grep "$*"
  fi
}

# permissions
perms () {
  find . -type d -exec chmod 770 {} \;
  find . -type f -exec chmod 660 {} \;
}
 
# search
ss() { find . | xargs grep "$1" -sl }

# aptitude
alias  a='sudo aptitude install'
alias au='sudo aptitude update && sudo aptitude safe-upgrade'
alias ai='aptitude show'
alias as='aptitude search'
alias lsa='ls_extended -Alsh'
alias ls='ls_extended'

# ssh
ssh_agent() {
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    pkill ssh-agent
    eval $(ssh-agent)
    ssh-add
  fi
}
# PATHS
[[ -s /etc/profile.d/autojump.sh ]] && . /etc/profile.d/autojump.sh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.profile
#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source  ~/powerlevel9k/powerlevel9k.zsh-theme
