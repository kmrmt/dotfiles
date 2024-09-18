# env
export SHELL=/bin/zsh
export EDITOR=vim

# tools
type docker > /dev/null && . <(docker completion zsh)
type kubectl > /dev/null && . <(kubectl completion zsh)
type go > /dev/null && go env -w GOPATH=$HOME/.ghq
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# alias
type rg > /dev/null && alias grep='rg'
type eza > /dev/null && alias ls='eza --icons'
type bat > /dev/null && alias cat='bat'
type fd > /dev/null && alias find='fd'
type ncdu > /dev/null && alias du='ncdu'
type btm > /dev/null && alias top='btm'
type procs > /dev/null && alias ps='procs'

# functions
function fuzzy-select-history () {
  BUFFER=$(history -n -r 1 | sk --query "$LBUFFER" --reverse)
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N fuzzy-select-history
bindkey '^r' fuzzy-select-history

function fuzzy-select-ghq () {
  local dst=$(ghq list --full-path | sk --exit-0 --layout=reverse --no-multi --preview "bat --color=always --style=header,grid --line-range :80 {}/README*")
  if [ -n "$dst" ]; then
    BUFFER="cd $dst"
    zle accept-line
  fi
}
zle -N fuzzy-select-ghq
bindkey '^g' fuzzy-select-ghq

function fuzzy-select-switch-branch () {
  local branch=$(git branch -a | rg -v '^\*|HEAD|^$' \
    | sk --exit-0 --layout=reverse --no-multi --preview-window="right,50%" --prompt="SWITCH BRANCH > " --preview='echo {} | tr -d " *" | xargs git log --graph --decorate --abbrev-commit --format=format:"%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset)%C(yellow)%d%C(reset)\n  %C(white)%s%C(reset) %C(dim white)- %an%C(reset)" --color=always' \
    | sed -e 's@remotes/origin/@@g')
  if [ -n "$branch" ]; then
    BUFFER="git switch $branch"
    zle accept-line
  fi
}
zle -N fuzzy-select-switch-branch
bindkey '^b' fuzzy-select-switch-branch
