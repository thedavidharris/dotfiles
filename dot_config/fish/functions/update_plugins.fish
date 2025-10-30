# Update all fish plugins
# Usage: update_plugins
function update_plugins
    echo "Updating fish plugins..."

    # Update fisher plugins
    if command -v fisher > /dev/null
        echo "Updating fisher plugins..."
        fisher update
    end

    echo "Plugin update complete!"
end
