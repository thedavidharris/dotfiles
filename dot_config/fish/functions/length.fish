# =============================================================================
# Get Length of String or Array
# =============================================================================

function length -d "Get the length of a string or count of array elements"
    if test (count $argv) -eq 0
        echo "Usage: length <string|array>"
        return 1
    end

    # Count number of arguments
    echo (count $argv)
end

