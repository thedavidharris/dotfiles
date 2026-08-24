function git_init_worktree -d "move the current directory to a child directory and make it the default branch in a new repository"
    set repository_name $(basename $(pwd))
    set default_branch $(git config --get init.defaultBranch)
    git init --bare .git
    git worktree add --orphan $default_branch
    mv (ls -A | grep -v '^\.git$\|^'"$default_branch"'$') $default_branch/
end
