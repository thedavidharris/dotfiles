# Path to dotfiles repo
export DOTFILES="$(dirname "$(readlink "$HOME/.zshrc")")"

zstyle ':znap:*' plugins-dir $DOTFILES/zsh/znap-plugins
source $DOTFILES/zsh/zsh-snap/znap.zsh


# Prompt
znap prompt pure

# Oh-My-Zsh Extensions
znap source ohmyzsh/ohmyzsh lib/{completion,git,nvm}

znap source ohmyzsh/ohmyzsh plugin/chruby
znap source ohmyzsh/ohmyzsh plugin/git
znap source ohmyzsh/ohmyzsh plugin/jenv
znap source ohmyzsh/ohmyzsh plugin/npm
znap source ohmyzsh/ohmyzsh plugin/nvm
znap source ohmyzsh/ohmyzsh plugin/osx

# Options
# setopt autocd autopushd cdsilent chaselinks pushdignoredups pushdsilent
# setopt NO_caseglob extendedglob globdots globstarshort nullglob numericglobsort
# setopt histfcntllock histignorealldups histsavenodups sharehistory
# setopt NO_flowcontrol interactivecomments rcquotes

# Environment variables
# export LANG='en_US.UTF-8'
# export EDITOR='code'
# export VISUAL='code'
# export CLICOLOR=1
# export CLICOLOR_FORCE=1

# Syntax highlighting in `less` and `man`
export PAGER='less'
export LESS='-giR'
export READNULLCMD='bat'
export MANPAGER="sh -c 'col -bpx | bat -l man -p'"
export BAT_PAGER="less $LESS"

# Real-time auto-completion
# https://github.com/marlonrichert/zsh-autocomplete
# znap source zsh-autocomplete

# In-line suggestions
znap source zsh-autosuggestions
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=( "${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[@]:#*forward-char}" )
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=( forward-char vi-forward-char )

# Better line editing tools
# https://github.com/marlonrichert/zsh-edit
znap source zsh-edit
WORDCHARS='*?\'

# History editing tools
# https://github.com/marlonrichert/zsh-hist
znap source zsh-hist
bindkey '^[q' push-line-or-edit

# Colors
# https://github.com/marlonrichert/
znap source marlonrichert/zcolors
znap eval zcolors "zcolors ${(q)LS_COLORS}"

# Command-line syntax highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-syntax-highlighting



# Find all zsh files
# configs=($DOTFILES/zsh/*.zsh)
# for file in "${configs[@]}"
# do
#   source "$file"
# done
