# Update all fish plugins
# Usage: update_plugins
function update_plugins
    echo "Updating fish plugins..."

    # Update fisher plugins
    if command -v fisher > /dev/null
        echo "Updating fisher plugins..."
        fisher update
    end

    # Update fzf if available
    if command -v fzf > /dev/null
        echo "Updating fzf..."
        cd ~/.fzf && git pull && ./install --bin
    end

    echo "Plugin update complete!"
end
