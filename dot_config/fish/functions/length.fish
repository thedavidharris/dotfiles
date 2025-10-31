# =============================================================================
# Get Length of String
# Count characters in input string or from stdin
# =============================================================================

function length -d "Count characters in a string or from stdin"
    if test (count $argv) -gt 0
        # Count characters in arguments
        string length -- "$argv"
    else
        # Count characters from stdin
        while read -l line
            echo (string length -- "$line")
        end
    end
end

