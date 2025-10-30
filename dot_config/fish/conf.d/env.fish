# All variables are universals here. They can be overridden with globals in config.fish

# Android SDK
set -q ANDROID_HOME; or set -Ux ANDROID_HOME $HOME/Library/Android/sdk

# Set editor variables.
set -q PAGER; or set -Ux PAGER less
set -q VISUAL; or set -Ux VISUAL code
set -q EDITOR; or set -Ux EDITOR nvim

# Set browser on macOS.
switch (uname -s)
    case Darwin
        set -q BROWSER; or set -Ux BROWSER open
end

# XDG apps
set -q LESSHISTFILE; or set -Ux LESSHISTFILE $XDG_DATA_HOME/lesshst
set -q SQLITE_HISTORY; or set -Ux SQLITE_HISTORY $XDG_DATA_HOME/sqlite_history
set -q GRADLE_USER_HOME; or set -Ux GRADLE_USER_HOME $XDG_CONFIG_HOME/gradle
set -q PYLINTHOME; or set -Ux PYLINTHOME $XDG_CACHE_HOME/pylint

# Tool-specific environment variables
set -q PYTHONIOENCODING; or set -Ux PYTHONIOENCODING UTF-8
set -q CLICOLOR; or set -Ux CLICOLOR 1
set -q LESS; or set -Ux LESS "ij.5KMRX"
set -q RIPGREP_CONFIG_PATH; or set -Ux RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/ripgreprc"

# Man page configuration
set -q MANPAGER; or set -Ux MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Colorize man pages
set -q LESS_TERMCAP_mb; or set -Ux LESS_TERMCAP_mb (set_color -o blue)
set -q LESS_TERMCAP_md; or set -Ux LESS_TERMCAP_md (set_color -o cyan)
set -q LESS_TERMCAP_me; or set -Ux LESS_TERMCAP_me (set_color normal)
set -q LESS_TERMCAP_so; or set -Ux LESS_TERMCAP_so (set_color -b white black)
set -q LESS_TERMCAP_se; or set -Ux LESS_TERMCAP_se (set_color normal)
set -q LESS_TERMCAP_us; or set -Ux LESS_TERMCAP_us (set_color -u magenta)
set -q LESS_TERMCAP_ue; or set -Ux LESS_TERMCAP_ue (set_color normal)

# Language and Locale
set -q LANG; or set -Ux LANG en_US.UTF-8
set -q LC_ALL; or set -Ux LC_ALL en_US.UTF-8
