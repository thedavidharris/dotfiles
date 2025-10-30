# =============================================================================
# Benchmark Fish Shell Startup
# Based on mattmc3/fishconf implementation
# =============================================================================

function benchmark -d "Benchmark fish shell startup time"
    set -l iterations 10

    # Parse arguments
    if test (count $argv) -gt 0
        set iterations $argv[1]
    end

    echo "🐟 Benchmarking fish startup time ($iterations iterations)..."
    echo ""

    # Profile startup with detailed output
    set -l profile_file (mktemp)
    fish --profile-startup=$profile_file -c exit

    echo "📊 Detailed Profile (first 10 significant operations):"
    awk 'NR==1 || $3==">"{print}' $profile_file | head -11 | string replace $HOME '~'
    echo ""

    # Run benchmark iterations
    echo "⏱️  Timing $iterations shell startups:"
    for i in (seq 1 $iterations)
        /usr/bin/time fish -i -c exit 2>&1 | grep real
    end

    # Clean up
    rm -f $profile_file

    echo ""
    echo "✅ Benchmark complete!"
    echo "💡 Tip: For detailed profiling, run:"
    echo "   fish --profile-startup=\$__fish_config_dir/fishprof.txt -c exit"
end
