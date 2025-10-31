# =============================================================================
# Paste from Clipboard
# Paste data from system clipboard
# =============================================================================

function clippaste -d "Paste data from clipboard"
    set --local ostype (uname -s)
    if test $ostype = Darwin
        pbpaste
    else
        echo >&2 "Unsupported OS: '$ostype'."
    end
end
