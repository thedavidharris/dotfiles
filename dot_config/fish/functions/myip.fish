# =============================================================================
# Get IP Address Information
# =============================================================================

function myip -d "Get your local and public IP addresses"
    echo "🌐 Network Information:"
    echo ""

    # Local IP (macOS)
    if command -v ipconfig >/dev/null 2>&1
        set -l local_ip (ipconfig getifaddr en0 2>/dev/null)
        if test -n "$local_ip"
            echo "📍 Local IP (Wi-Fi):  $local_ip"
        end

        set -l ethernet_ip (ipconfig getifaddr en1 2>/dev/null)
        if test -n "$ethernet_ip"
            echo "📍 Local IP (Ethernet): $ethernet_ip"
        end
    else if command -v hostname >/dev/null 2>&1
        # Linux fallback
        set -l local_ip (hostname -I 2>/dev/null | awk '{print $1}')
        if test -n "$local_ip"
            echo "📍 Local IP: $local_ip"
        end
    end

    echo ""

    # Public IP
    echo "🌍 Fetching public IP..."
    if command -v curl >/dev/null 2>&1
        set -l public_ip (curl -s https://api.ipify.org 2>/dev/null)
        if test -n "$public_ip"
            echo "🌍 Public IP: $public_ip"
        else
            echo "❌ Could not fetch public IP"
        end
    else
        echo "❌ curl not found - cannot fetch public IP"
    end
end

