# =============================================================================
# Paste from Clipboard
# Paste data from system clipboard
# =============================================================================

function clippaste -d "Paste data from clipboard"
    set --local ostype (uname -s)
    if test $ostype = Darwin
        pbpaste
    else if command -v xclip >/dev/null 2>&1
        xclip -selection clipboard -o
    else if command -v wl-paste >/dev/null 2>&1
        wl-paste
    else if command -v powershell.exe >/dev/null 2>&1
        powershell.exe -NoProfile -Command "Get-Clipboard" | tr -d '\r'
    else
        echo >&2 "Unsupported OS: '$ostype'."
    end
end
