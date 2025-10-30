# =============================================================================
# Get Main Branch Name
# Detect if repo uses 'main' or 'master'
# =============================================================================

function git-main-branch -d "Get the main branch name (main or master)"
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "master"
        return
    end

    # Check for main branch
    if git show-ref --verify --quiet refs/heads/main
        echo "main"
    # Check for master branch
    else if git show-ref --verify --quiet refs/heads/master
        echo "master"
    # Fallback
    else
        echo "main"
    end
end

