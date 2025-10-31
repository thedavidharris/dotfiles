# =============================================================================
# Create Temporary Scratch File
# Create and edit a temporary file for quick notes or testing
# =============================================================================

function scratch -d "Create and edit a temporary file"
    if test (count $argv) -eq 0
        # Create temp file with random name
        set file (mktemp)
    else
        # Create temp file with specified name
        set file (mktemp --suffix="-$argv[1]")
    end

    echo "Editing temporary file: $file"
    $EDITOR "$file"
end
