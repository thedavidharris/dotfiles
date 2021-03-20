# Path to your oh-my-zsh installation.
export ZSH="/Users/dharr419/.oh-my-zsh"

# Path to dotfiles repo
export DOTFILES="$(dirname "$(readlink "$HOME/.zshrc")")"

source $DOTFILES/zsh/antigen/antigen.zsh
antigen init .antigenrc

autoload -U promptinit; promptinit
prompt pure

# Find all zsh files
configs=($DOTFILES/zsh/*.zsh)
for file in "${configs[@]}"
do
  source "$file"
done

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes
