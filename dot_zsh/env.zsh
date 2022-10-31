if [[ $OSTYPE == darwin* ]]; then
  export OSX=true
fi

# Make history a bit bigger than macOS default.
SAVEHIST=2000
HISTSIZE=$(( 1.2 * SAVEHIST))  # Zsh recommended value

# Set default editor to Vim
export EDITOR=vim

# i - Vim's smart case
# j.5 - Center search results
# K - Quit on CTRL-C
# M - Longer prompt
# R - output colors correctly
# X - Don't send clear screen signal
export LESS="ij.5KMRX"
export PAGER="less"

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

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

export PAGER='less'
export LESS='-giR'
export READNULLCMD='bat'
export MANPAGER="sh -c 'col -bpx | bat -l man -p'"
export BAT_PAGER="less $LESS"


export CLICOLOR=1
export CLICOLOR_FORCE=1


# OSX Things


# Disable fastlane stuff
export FASTLANE_OPT_OUT_USAGE=1
export FASTLANE_SKIP_UPDATE_CHECK=1

# Disable CocoaPods stats
export COCOAPODS_DISABLE_STATS=1