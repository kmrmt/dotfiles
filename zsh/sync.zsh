HISTFILE=$HOME/.zsh_hist
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_save_no_dups
setopt share_history
setopt autocd
setopt auto_list
setopt auto_menu
setopt notify
setopt extendedglob
setopt noflowcontrol
setopt correct
unsetopt beep

bindkey -e

zmodload zsh/zpty
