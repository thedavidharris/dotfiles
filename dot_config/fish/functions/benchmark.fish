# Benchmark fish startup time
# Usage: benchmark
function benchmark
    echo "Benchmarking fish startup time..."
    time fish -i -c exit
end
