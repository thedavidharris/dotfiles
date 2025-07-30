# Set Zsh options related to globbing.
setopt extended_glob         # Use more awesome globbing features.
setopt NO_rm_star_silent     # Ask for confirmation for `rm *' or `rm path/*'

# Set general Zsh options.
setopt combining_chars       # Combine 0-len chars with the base character (eg: accents).
setopt interactive_comments  # Enable comments in interactive shell.
setopt rc_quotes             # Allow 'Hitchhikers''s Guide' instead of 'Hitchhikers'\''s Guide'.
setopt NO_mail_warning       # Don't print a warning message if a mail file has been accessed.
setopt NO_beep               # Don't beep on error in line editor.

# Set Zsh options related to job control.
setopt auto_resume           # Attempt to resume existing job before creating a new process.
setopt long_list_jobs        # List jobs in the long format by default.
setopt notify                # Report status of background jobs immediately.
setopt NO_bg_nice            # Don't run all background jobs at a lower priority.
setopt NO_check_jobs         # Don't report on jobs when shell exit.
setopt NO_hup                # Don't kill jobs on shell exit.

# XDG base dirs already set in .zshenv - no need to duplicate


# Set browser.
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER=${BROWSER:-open}
fi

# Set language and locale
export LANG=${LANG:-en_US.UTF-8}
export LC_ALL='en_US.UTF-8'

# Reduce key delay
export KEYTIMEOUT=${KEYTIMEOUT:-1}

# Use `< file` to quickly view the contents of any file.
[[ -z "$READNULLCMD" ]] || READNULLCMD=$PAGER

# Set default editor to Neovim
export EDITOR=nvim

export VISUAL=code

# FZF setup and colors
if command -v fzf &> /dev/null; then
  # Source fzf key bindings and completion
  eval "$(fzf --zsh)"
  # Source official Catppuccin Macchiato theme
  [[ -f ~/.config/fzf/catppuccin-fzf-macchiato.sh ]] && source ~/.config/fzf/catppuccin-fzf-macchiato.sh
fi

# EXA/EZA colors - inherit from LS_COLORS and enhance
export EXA_COLORS="$LS_COLORS"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8'

export CLICOLOR=1

export GRADLE_USER_HOME=$XDG_CONFIG_HOME/gradle

export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# i - Vim's smart case
# j.5 - Center search results
# K - Quit on CTRL-C
# M - Longer prompt
# R - output colors correctly
# X - Don't send clear screen signal
export LESS="ij.5KMRX"
# On macOS _something_ is setting this which breaks default behavior like 'man
# libtool' pointing at Xcode
export MANPATH=
