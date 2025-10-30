# =============================================================================
# Get Current Git Branch Name
# =============================================================================

function git-branch-current -d "Get current git branch name"
    if not git rev-parse --git-dir >/dev/null 2>&1
        return 1
    end

    git branch --show-current
end

