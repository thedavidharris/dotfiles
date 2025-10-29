# Create and enter a new directory
# Usage: mkcd my-new-folder
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end
