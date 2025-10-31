# =============================================================================
# Expand Dots to Parent Path
# Expand ... to ../.. etc for directory navigation
# =============================================================================

function expand_dots_to_parent_path -d "Expand ... to ../.. etc"
    # Get commandline up to cursor
    set --local cmd (commandline --cut-at-cursor)

    # Match last line
    switch $cmd[-1]
        case '*..'
            commandline --insert '/..'
        case '*'
            commandline --insert '.'
    end
end
