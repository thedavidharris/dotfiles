# =============================================================================
# Reverse Cat
# Display file contents in reverse order
# =============================================================================

function tac -d "Display file contents in reverse order"
    if type -q tac
        tac $argv
    else
        cat $argv | awk '{a[NR]=$0}END{for(i=NR;i>0;i--)print a[i]}'
    end
end
