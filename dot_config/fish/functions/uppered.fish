# =============================================================================
# Convert String to Uppercase
# =============================================================================

function uppered -d "Convert string to uppercase"
    if test (count $argv) -eq 0
        # Read from stdin
        string upper
    else
        # Use arguments
        string upper -- $argv
    end
end

