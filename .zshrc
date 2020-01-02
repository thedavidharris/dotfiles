# Path to your oh-my-zsh installation.
export ZSH="/Users/dharr419/.oh-my-zsh"

# Path to dotfiles repo
export DOTFILES="$(dirname "$(readlink "$HOME/.zshrc")")"

ZSH_CUSTOM=$DOTFILES/zsh/custom

ZSH_THEME=""

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
            # Bundled
            chruby
            # colorize # Need to install pygments
            git
            npm
            nvm

            osx
            pod
            swiftpm

            # Custom
            my_aliases
            my_env
            my_osx
        )

source $ZSH/oh-my-zsh.sh

fpath+=("$DOTFILES/zsh/pure")
autoload -U promptinit; promptinit
prompt pure
