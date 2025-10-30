# =============================================================================
# Pretty Print PATH
# Display PATH variable in a readable format
# =============================================================================

function prettypath -d "Pretty print PATH variable"
    if test (count $argv) -eq 0
        # Print PATH
        string replace : \n $PATH
    else
        # Print any other path variable
        string replace : \n $$argv[1]
    end
end

