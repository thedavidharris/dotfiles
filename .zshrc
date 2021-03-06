# Path to dotfiles repo
export DOTFILES="$(dirname "$(readlink "$HOME/.zshrc")")"

zstyle ':znap:*' plugins-dir $DOTFILES/zsh/znap-plugins
source $DOTFILES/zsh/zsh-snap/znap.zsh


# Prompt
znap prompt pure

# Oh-My-Zsh Extensions
znap source ohmyzsh/ohmyzsh plugins/chruby
znap source ohmyzsh/ohmyzsh plugins/colored-man-pages
znap source ohmyzsh/ohmyzsh plugins/jenv


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

# Touchbar
znap source zsh-users/zsh-apple-touchbar

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



