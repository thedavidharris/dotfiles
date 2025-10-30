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

# Language and Locale
set -q LANG; or set -Ux LANG en_US.UTF-8
set -q LC_ALL; or set -Ux LC_ALL en_US.UTF-8

# Other vars
set -q FISH_THEME; or set -U FISH_THEME "default"
