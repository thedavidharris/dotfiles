# =============================================================================
# Extract Archives
# Universal extraction function for various archive formats
# Modern tar auto-detects compression types
# =============================================================================

function extract -d "Extract various archive formats"
    if test (count $argv) -eq 0
        echo "Usage: extract <archive>..."
        echo "Supported: tar.*, zip, rar, 7z, gz, bz2, xz, Z"
        return 1
    end

    for file in $argv
        if not test -f $file
            echo "❌ '$file' does not exist" >&2
            continue
        end

        switch $file
            # Tar archives (auto-detects compression: gzip, bzip2, xz, zstd, etc.)
            case '*.tar' '*.tar.*' '*.tgz' '*.tbz' '*.tbz2' '*.txz' '*.tzst'
                tar xf $file && echo "✅ Extracted: $file"

            # Standalone compressed files
            case '*.gz'
                gunzip $file && echo "✅ Decompressed: $file"
            case '*.bz2'
                bunzip2 $file && echo "✅ Decompressed: $file"
            case '*.xz'
                unxz $file && echo "✅ Decompressed: $file"
            case '*.Z'
                uncompress $file && echo "✅ Decompressed: $file"
            case '*.zst'
                unzstd $file && echo "✅ Decompressed: $file"

            # Other archive formats
            case '*.zip' '*.jar'
                unzip -q $file && echo "✅ Extracted: $file"
            case '*.rar'
                unrar x -inul $file && echo "✅ Extracted: $file"
            case '*.7z'
                7z x -bso0 $file && echo "✅ Extracted: $file"

            case '*'
                echo "❌ Unknown archive format: $file" >&2
                return 1
        end
    end
end
