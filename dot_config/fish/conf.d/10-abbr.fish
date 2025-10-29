# Fish Abbreviations (better than aliases)
# Abbreviations expand before execution and show the full command

# =============================================================================
# NAVIGATION ABBREVIATIONS
# =============================================================================

abbr --add .. "cd .."
abbr --add ... "cd ../.."
abbr --add .... "cd ../../.."
abbr --add ..... "cd ../../../.."
abbr --add -- - "cd -"

# =============================================================================
# GIT ABBREVIATIONS
# =============================================================================

abbr --add g "git"
abbr --add gs "git status"
abbr --add ga "git add"
abbr --add gc "git commit"
abbr --add gp "git push"
abbr --add gl "git pull"
abbr --add gd "git diff"
abbr --add gds "git diff --staged"
abbr --add gco "git checkout"
abbr --add gb "git branch"
abbr --add glog "git log --oneline --graph --decorate"

# =============================================================================
# CHEZMOI ABBREVIATIONS
# =============================================================================

abbr --add cm "chezmoi"
abbr --add cma "chezmoi apply"
abbr --add cmd "chezmoi diff"
abbr --add cms "chezmoi status"

# =============================================================================
# MODERN TOOL ABBREVIATIONS (conditional on availability)
# =============================================================================

# Modern ls alternatives
if command -v eza > /dev/null
    abbr --add ls "eza --color=always --group-directories-first"
    abbr --add la "eza -la --color=always --group-directories-first"
    abbr --add ll "eza -l --color=always --group-directories-first"
    abbr --add l "eza -CF --color=always --group-directories-first"
    abbr --add tree "eza --tree"
    abbr --add lt "eza --tree --level=2"
    abbr --add lta "eza --tree --all"
end

# Modern alternatives
if command -v fd > /dev/null
    abbr --add find "fd"
    abbr --add fdi "fd -i"
end

if command -v rg > /dev/null
    abbr --add grep "rg"
    abbr --add rgi "rg -i"
    abbr --add rgu "rg -uu"
end

if command -v bat > /dev/null
    abbr --add cat "bat --paging=never"
    abbr --add less "bat --paging=always"
end

if command -v delta > /dev/null
    abbr --add diff "delta"
end

if command -v dust > /dev/null
    abbr --add du "dust"
    abbr --add dusts "dust -s"
end

if command -v procs > /dev/null
    abbr --add ps "procs"
    abbr --add procsj "procs --json"
end

# =============================================================================
# SYSTEM UTILITIES
# =============================================================================

# Enable aliases to be sudo'ed (Fish doesn't have this issue, but for compatibility)
abbr --add sudo "sudo "

# Quick directory navigation
abbr --add cdd "cd ~/Desktop"
abbr --add cdl "cd ~/Downloads"
abbr --add cdo "cd ~/Documents"

# Reload the shell
abbr --add reload "exec fish -l"

# Print each PATH entry on a separate line
abbr --add path "echo \$PATH | tr ':' '\n'"
