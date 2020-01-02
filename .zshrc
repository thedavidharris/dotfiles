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
