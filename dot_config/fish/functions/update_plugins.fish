function update_plugins --description 'Update installed Fish plugins'
    if not type -q fisher
        echo >&2 'Run chezmoi apply to install Fisher first.'
        return 1
    end
    fisher update
end
