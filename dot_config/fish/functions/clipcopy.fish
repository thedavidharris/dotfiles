# =============================================================================
# Copy to Clipboard
# Copy data to system clipboard
# =============================================================================

function clipcopy -d "Copy data to clipboard"
    set --local clip_cmd
    if test (uname -s) = Darwin
        set clip_cmd pbcopy
    else if command -v xclip >/dev/null 2>&1
        set clip_cmd xclip -selection clipboard
    else if command -v wl-copy >/dev/null 2>&1
        set clip_cmd wl-copy
    else if command -v clip.exe >/dev/null 2>&1
        set clip_cmd clip.exe
    else
        echo >&2 "clipcopy: no clipboard provider found."
        return 1
    end

    if test (count $argv) -eq 0
        cat | $clip_cmd
    else
        cat $argv | $clip_cmd
    end
end
