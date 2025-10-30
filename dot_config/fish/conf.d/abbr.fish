#
# abbrs
#

set -q MY_ABBRS_INITIALIZED; and return

# =============================================================================
# NAVIGATION ABBREVIATIONS
# =============================================================================

abbr -a -- - 'cd -'
abbr -a -- .. "cd .."
abbr -a -- ... "cd ../.."
abbr -a -- .... "cd ../../.."
abbr -a -- ..... "cd ../../../.."

abbr -a -- fconf 'cd $__fish_config_dir'
abbr -a -- fishconf 'cd $__fish_config_dir'
abbr -a -- fdot 'cd $__fish_config_dir'
abbr -a -- zdot 'cd $ZDOTDIR'

# =============================================================================
# MODERN TOOL ABBREVIATIONS (conditional on availability)
# =============================================================================

# Modern ls alternatives
if command -v eza >/dev/null
    abbr -a -- ls "eza --color=always --group-directories-first"
    abbr -a -- la "eza -la --color=always --group-directories-first"
    abbr -a -- ll "eza -l --color=always --group-directories-first"
    abbr -a -- l "eza -CF --color=always --group-directories-first"
    abbr -a -- tree "eza --tree"
    abbr -a -- lt "eza --tree --level=2"
    abbr -a -- lta "eza --tree --all"
end

# Modern alternatives
if command -v fd >/dev/null
    abbr -a -- find "fd"
    abbr -a -- fdi "fd -i"
end

if command -v rg >/dev/null
    abbr -a -- grep "rg"
    abbr -a -- rgi "rg -i"
    abbr -a -- rgu "rg -uu"
end

if command -v bat >/dev/null
    abbr -a -- cat "bat --paging=never"
    abbr -a -- less "bat --paging=always"
end

if command -v delta >/dev/null
    abbr -a -- diff "delta"
end

if command -v dust >/dev/null
    abbr -a -- du "dust"
    abbr -a -- dusts "dust -s"
end

if command -v procs >/dev/null
    abbr -a -- ps "procs"
    abbr -a -- procsj "procs --json"
end

# =============================================================================
# SYSTEM UTILITIES
# =============================================================================

# Enable aliases to be sudo'ed
abbr -a -- sudo "sudo "

# Reload the shell
abbr -a -- reload "exec fish -l"

# no need to run over-and-over
set -g MY_ABBRS_INITIALIZED true
