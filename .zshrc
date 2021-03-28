# Path to dotfiles repo
export DOTFILES="$(dirname "$(readlink "$HOME/.zshrc")")"

zstyle ':znap:*' plugins-dir $DOTFILES/zsh/znap-plugins
source $DOTFILES/zsh/zsh-snap/znap.zsh


# Prompt
znap prompt pure

# Oh-My-Zsh Extensions
# Would like to remove sometime

# Options


# Environment variables
# export LANG='en_US.UTF-8'
# export EDITOR='code'
# export VISUAL='code'
# export CLICOLOR=1
# export CLICOLOR_FORCE=1

# Syntax highlighting in `less` and `man`


# Completions
znap source zsh-users/zsh-completions

# Real-time auto-completion
# https://github.com/marlonrichert/zsh-autocomplete
# znap source marlonrichert/zsh-autocomplete

# In-line suggestions
znap source zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=( "${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[@]:#*forward-char}" )
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=( forward-char vi-forward-char )

# Better line editing tools
# https://github.com/marlonrichert/zsh-edit
znap source marlonrichert/zsh-edit
WORDCHARS='*?\'

# History editing tools
# https://github.com/marlonrichert/zsh-hist
znap source marlonrichert/zsh-hist
bindkey '^[q' push-line-or-edit

# Colors
# https://github.com/marlonrichert/
znap source marlonrichert/zcolors
znap eval zcolors "zcolors ${(q)LS_COLORS}"

# Command-line syntax highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting

# nvm
znap source lukechilds/zsh-nvm

# Find all zsh custom plugin files
plugins=($DOTFILES/zsh/plugins/*.zsh)
for file in "${plugins[@]}"
do
  source "$file"
done

# Source something from all shells for private ENV vars
if [[ -f "$HOME/.secrets" ]]; then
  source "$HOME/.secrets"
fi



