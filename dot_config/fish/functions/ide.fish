# =============================================================================
# Open IDE in Project Directory
# Open project directory in $VISUAL editor
# =============================================================================

function ide -d "Use $VISUAL to open a project directory"
    set --local dir (string match -r '.' $argv '.')[1]
    set -q VISUAL || set -gx VISUAL vim
    $VISUAL $dir
end
