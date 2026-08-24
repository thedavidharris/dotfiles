function git_clone_worktree -d "make a bare clone of the given repository and creates a work tree for the default branch"
    set repository_url $argv[1]
    set repository_name $(basename $repository_url .git)
    git clone --bare $repository_url $repository_name/.git
    cd $repository_name
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch
    set default_branch $(git remote show $(git remote) | awk '/HEAD branch/ {print $NF}')
    git worktree add $default_branch
end
