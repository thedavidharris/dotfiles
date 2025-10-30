# =============================================================================
# Git Push with Tracking
# Push current branch and set upstream
# =============================================================================

function gp -d "Git push with upstream tracking"
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository" >&2
        return 1
    end

    set -l current_branch (git branch --show-current)

    if test -z "$current_branch"
        echo "❌ Not on a branch" >&2
        return 1
    end

    # Check if upstream is set
    if not git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1
        echo "🔗 Setting upstream for branch: $current_branch"
        git push --set-upstream origin $current_branch
    else
        git push
    end
end

