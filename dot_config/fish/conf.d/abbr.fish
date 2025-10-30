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

# =============================================================================
# GIT ABBREVIATIONS
# =============================================================================

abbr -a -- g "git"
abbr -a -- gs "git status"
abbr -a -- ga "git add"
abbr -a -- gc "git commit"
abbr -a -- gp "git push"
abbr -a -- gl "git pull"
abbr -a -- gd "git diff"
abbr -a -- gds "git diff --staged"
abbr -a -- gco "git checkout"
abbr -a -- gb "git branch"
abbr -a -- glog "git log --oneline --graph --decorate"

# =============================================================================
# CHEZMOI ABBREVIATIONS
# =============================================================================

abbr -a -- cm "chezmoi"
abbr -a -- cma "chezmoi apply"
abbr -a -- cmd "chezmoi diff"
abbr -a -- cms "chezmoi status"

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

# Quick directory navigation
abbr -a -- cdd "cd ~/Desktop"
abbr -a -- cdl "cd ~/Downloads"
abbr -a -- cdo "cd ~/Documents"

# Reload the shell
abbr -a -- reload "exec fish -l"

# Print each PATH entry on a separate line
abbr -a -- path "echo \$PATH | tr ':' '\n'"

# no need to run over-and-over
set -g MY_ABBRS_INITIALIZED true
