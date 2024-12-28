if [[ $OSTYPE == darwin* ]]; then
  export OSX=true
fi

# Make history a bit bigger than macOS default.
SAVEHIST=2000
HISTSIZE=$(( 1.2 * SAVEHIST))  # Zsh recommended value

# Set default editor to Neovim
export EDITOR=nvim

export VISUAL=code

# Disable ^-S in the terminal
stty -ixon -ixoff

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty)

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

export CLICOLOR=1

export NVM_DIR=$HOME/nvm
export GRADLE_USER_HOME=$HOME/gradle