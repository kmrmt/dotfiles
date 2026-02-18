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

LAST_UPDATE="$(dirname $0)/last_update"
UPDATE_INTERVAL="$((12 * 60 * 60))"

update_system() {
  echo "================================================"
  echo "🚨 Starting system update..."
  echo "================================================"

  echo "▶️ reflector: Updating mirror list..."
  sudo reflector --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

  echo "▶️ pacman: Updating pacman..."
  sudo pacman -Syu

  echo "▶️ paru: Updating AUR packages..."
  paru -Syu

  echo "▶️ mise: Running self-update..."
  mise self-update

  echo "▶️ mise: Update tools..."
  mise up

  st=$?
  if [ "$st" -eq 0 ]; then
    date +%s > "$LAST_UPDATE"
    echo "✅ All updates are complete. Last update time has been recorded."
  else
    echo "❌ An error occurred during the update process. The update time will not be recorded."
  fi

  echo "================================================"
  return $st
}

check_and_update_system() {
  if [ -f "$LAST_UPDATE" ]; then
    LAST_CHECK=$(cat "$LAST_UPDATE")
  else
    LAST_CHECK=0
  fi

  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$(( CURRENT_TIME - LAST_CHECK ))

  if [ "$ELAPSED_TIME" -ge "$UPDATE_INTERVAL" ]; then
    echo "================================================"
    echo "🚨 Automatic update triggered."
    echo "More than $(($ELAPSED_TIME / 3600)) hours have passed since the last update."

    update_system
  fi
}

check_and_update_system
