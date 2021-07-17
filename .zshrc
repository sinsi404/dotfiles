### Installation
## Install z.sh
# git clone https://github.com/rupa/z.git ~/.zsh.d

## Install peco
# ARCH=linux_amd64 / linux_arm64 / darwin_amd64 / darwin_arm64
#
# (Linux)
# curl -L -O https://github.com/peco/peco/releases/download/v0.5.10/peco_${ARCH}.tar.gz
# tar zxf peco_${ARCH}.tar.gz
# sudo mv peco_${ARCH}/peco /usr/local/bin/peco
# rm -rf peco_${ARCH}.tar.gz peco_${ARCH}
#
# (Mac)
# curl -L -O https://github.com/peco/peco/releases/download/v0.5.10/peco_${ARCH}.zip
# unzip peco_${ARCH}.zip
# sudo mv peco_${ARCH}/peco /usr/local/bin/peco
# rm -rf peco_${ARCH}.zip peco_${ARCH}

# keybind
bindkey -e

# env
export VISUAL=vim
export EDITOR=$VISUAL
export GIT_EDITOR=$VISUAL

# peco z search(Ctrl-r)
function peco-z-search
{
  which peco z > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install peco and z"
    return 1
  fi
  local res=$(z | sort -rn | cut -c 12- | peco)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N peco-z-search
bindkey '^r' peco-z-search
source ~/.zsh.d/z.sh


# history
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

HISTFILE=~/.zsh_history
HISTFSIZE=1000000
SAVESIZE=1000000
setopt hist_ignore_dups
setopt share_history

# completion
autoload -U compinit && compinit -U
zstyle ':completion:*:default' menu select=1
setopt menu_complete
zmodload zsh/complist
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'l' forward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect '^i' accept-and-infer-next-history
bindkey -M menuselect '^k' accept-line
bindkey -M menuselect '^m' .accept-line
bindkey -M menuselect '^[[Z' reverse-menu-complete

# next/prev word
bindkey "^l" emacs-forward-word
bindkey "^o" emacs-backward-word

# delete to prev slash (Windows keyboard)
#backward-kill-to-slash () {
#  local WORDCHARS=${WORDCHARS/\/}
#  zle backward-kill-word
#}
#zle -N backward-kill-to-slash
#bindkey "^w" backward-kill-to-slash

# move to parent dir(Ctrl + U)
__call_precmds() {
  type precmd > /dev/null 2>&1 && precmd
  for __pre_func in $precmd_functions; do $__pre_func; done
}
__cd_up()   { builtin cd ..; echo "\r\n"; __call_precmds; zle reset-prompt }
zle -N __cd_up
bindkey '^u' __cd_up

# aliases
alias sz="source ~/.zshrc"
alias vz="vi ~/.zshrc"

# prompt
autoload -U vcs_info
zstyle ":vcs_info:*" formats "[%b]"
zstyle ":vcs_info:*" actionformats "[%b|%a]"
precmd () {
  print
  vcs_info
  local left="{%n@%m} ${vcs_inof_mse_0_}"
  local right="[%40<...<%~]"
  local invisible='%([BSUbfksu]|([FK]|){*})'
  local leftwidth=${#${(S%%)left//$~invisible/}}
  local rightwidth=${#${(S%%)right//$~invisible/}}
  local padwidth=$(($COLUMNS - ($leftwidth + $rightwidth) % $COLUMNS))

  print -P $left${(r:$padwidth:: :)}$right
}
PROMPT=$'\$ '
setopt NO_NOMATCH
