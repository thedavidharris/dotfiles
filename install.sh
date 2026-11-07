#!/bin/bash
# Run locally with `bash install.sh`, or download and run with `bash -c`.
set -euo pipefail
umask 077

case "$(uname -s)" in
    Darwin) ;;
    Linux)
        case "$HOME" in
            /mnt/*) echo >&2 'Run from your Linux home directory.'; exit 1 ;;
        esac
        if ! command -v gcc >/dev/null || ! command -v make >/dev/null ||
            ! command -v curl >/dev/null || ! command -v git >/dev/null ||
            ! command -v file >/dev/null || ! command -v ps >/dev/null; then
            sudo apt-get update
            sudo apt-get install -y build-essential procps curl file git
        fi
        ;;
    *) echo >&2 'This setup supports macOS and Linux. On Windows, run it inside WSL.'; exit 1 ;;
esac

if ! command -v brew >/dev/null; then
    for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
        if [[ -x "$brew_bin" ]]; then
            eval "$("$brew_bin" shellenv bash)"
            break
        fi
    done
fi
if ! command -v brew >/dev/null; then
    installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    /bin/bash -c "$installer"
    for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
        if [[ -x "$brew_bin" ]]; then
            eval "$("$brew_bin" shellenv bash)"
            break
        fi
    done
fi
if ! command -v brew >/dev/null; then
    echo >&2 'Homebrew installation is incomplete. Finish its setup and rerun this command.'
    exit 1
fi

# Use the Homebrew copy even if an older standalone binary is on PATH.
brew update
brew_prefix="$(brew --prefix)"
chezmoi_bin="$brew_prefix/bin/chezmoi"
[[ -x "$chezmoi_bin" ]] || brew install chezmoi

backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups"
mkdir -p "$backup_root"
backup_dir="$(mktemp -d "$backup_root/$(date +%Y%m%d-%H%M%S).XXXXXX")"
config_file="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.toml"
if [[ -f "$config_file" ]]; then
    cp -p "$config_file" "$backup_dir/chezmoi.toml"
fi
fish_state="${XDG_CONFIG_HOME:-$HOME/.config}/fish/fish_variables"
if [[ -f "$fish_state" ]]; then
    cp -p "$fish_state" "$backup_dir/fish_variables"
fi
"$chezmoi_bin" --destination "$HOME" init https://github.com/thedavidharris/dotfiles.git "$@"

# Back up existing managed files before applying. Local exclusions still apply.
targets="$(mktemp)"
trap 'rm -f "$targets"' EXIT
"$chezmoi_bin" --destination "$HOME" managed --override-data '{"installAgents":false}' --include files,symlinks --path-style absolute --nul-path-separator > "$targets"
while IFS= read -r -d '' target; do
    if [[ -e "$target" || -L "$target" ]]; then
        relative="${target#"$HOME"/}"
        mkdir -p "$backup_dir/$(dirname "$relative")"
        cp -pP "$target" "$backup_dir/$relative"
    fi
done < "$targets"
echo "Existing files backed up to $backup_dir"

# Install the core before private repos need SSH or 1Password.
"$chezmoi_bin" --destination "$HOME" apply --override-data '{"installAgents":false}'

if [[ "$("$chezmoi_bin" --destination "$HOME" execute-template '{{ .installAgents }}')" == true ]]; then
    "$chezmoi_bin" --destination "$HOME" apply
fi

echo "Setup complete. Start Fish with $brew_prefix/bin/fish"
