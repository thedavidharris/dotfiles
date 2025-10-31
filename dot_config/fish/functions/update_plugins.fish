# =============================================================================
# Update Fish Plugins
# Update all installed fish shell plugins
# =============================================================================

function update_plugins -d "Update all fish plugins"
    echo "Updating fish plugins..."

    # Update fisher plugins
    if command -v fisher > /dev/null
        echo "Updating fisher plugins..."
        fisher update
    else
        echo "Error: fisher not found" >&2
        return 1
    end

    echo "Plugin update complete!"
end
