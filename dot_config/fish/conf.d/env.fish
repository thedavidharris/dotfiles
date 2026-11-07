# Session defaults. Local config can override them.

# Browser (OS-dependent defaults).
set --local __os (uname -s)
switch $__os
    case Darwin
        set -q BROWSER; or set -gx BROWSER open
    case '*'
        set -q BROWSER; or set -gx BROWSER xdg-open
end

# Set editor variables.
set -q PAGER; or set -gx PAGER less
set -q VISUAL; or set -gx VISUAL code
set -q EDITOR; or set -gx EDITOR nvim

# XDG apps
set -q LESSHISTFILE; or set -gx LESSHISTFILE $XDG_DATA_HOME/lesshst
set -q SQLITE_HISTORY; or set -gx SQLITE_HISTORY $XDG_DATA_HOME/sqlite_history
set -q GRADLE_USER_HOME; or set -gx GRADLE_USER_HOME $XDG_CONFIG_HOME/gradle
set -q PYLINTHOME; or set -gx PYLINTHOME $XDG_CACHE_HOME/pylint

# Tool-specific environment variables
set -q PYTHONIOENCODING; or set -gx PYTHONIOENCODING UTF-8
set -q CLICOLOR; or set -gx CLICOLOR 1
set -q LESS; or set -gx LESS "ij.5KMRX"
set -q RIPGREP_CONFIG_PATH; or set -gx RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/ripgreprc"

# Other vars
set -q FISH_THEME; or set -g FISH_THEME "Catppuccin Macchiato"
