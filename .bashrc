# Path to dotfiles repo
export DOTFILES="$(dirname "$(readlink "$HOME/.bashrc")")"

configs=($DOTFILES/*/*.bash)
for file in "${configs[@]}"
do
  source "$file"
done
