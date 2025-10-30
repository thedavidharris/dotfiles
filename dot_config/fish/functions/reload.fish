# =============================================================================
# Reload Fish Configuration
# =============================================================================

function reload -d "Reload fish configuration"
    echo "🔄 Reloading fish configuration..."
    source $__fish_config_dir/config.fish
    echo "✅ Configuration reloaded!"
end

