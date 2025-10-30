# =============================================================================
# Convert String to Lowercase
# =============================================================================

function lowered -d "Convert string to lowercase"
    if test (count $argv) -eq 0
        # Read from stdin
        string lower
    else
        # Use arguments
        string lower -- $argv
    end
end

