# =============================================================================
# Git Status (Short Format)
# Quick git status with compact output
# =============================================================================

function gs -d "Git status (short format)"
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository" >&2
        return 1
    end

    git status --short --branch
end

