# David's Dotfiles

Fish, Neovim, and developer tools for macOS and Ubuntu on WSL 2, managed with
[chezmoi](https://www.chezmoi.io/). Homebrew installs packages and mise manages
language runtimes.

## Setup

On macOS, install the Xcode Command Line Tools with `xcode-select --install` if
needed. On WSL, run the setup inside Ubuntu. Install [Homebrew](https://brew.sh/)
and follow the installer's instructions to add it to your shell.

```sh
brew install chezmoi
chezmoi init https://github.com/thedavidharris/dotfiles.git
```

Choose your machine's work or personal profile when prompted. On a work machine,
enter the email you want Git and Fish to use. macOS system preferences are optional.

### First apply on macOS

Install 1Password with `brew install --cask 1password` if needed.
Apply local files first so you can set up the SSH agent before fetching the
private agent repos.

```sh
chezmoi diff --exclude scripts --override-data '{"offline":true}'
chezmoi apply --exclude scripts --override-data '{"offline":true}'
```

Unlock 1Password, enable its SSH agent, and check that your GitHub key has access
to the private repos.

### Apply dotfiles

Preview the changes, then apply the dotfiles, Homebrew packages, and Fish plugins.

```sh
chezmoi diff
chezmoi apply
mise install
fish
```

## Everyday use

- Preview changes with `chezmoi diff` and apply them with `chezmoi apply`.
- Edit managed files with `chezmoi edit`, or change the package list in
  [packages.yaml](.chezmoidata/packages.yaml).
- Put machine overrides under `[data]` in `~/.config/chezmoi/chezmoi.toml`.
  Use `keepLocal` to list home-relative paths chezmoi should skip.
  On WSL, set `installAgents = true` to opt into the private agent setup.
- Use `chezmoi init --prompt` to change the saved role or email. Init preserves
  `[data]` but regenerates other settings, so save any custom settings first.

Run `python3 scripts/check-bootstrap.py` to check changes locally. It needs
Python 3.11+, chezmoi, Fish, and ShellCheck and uses temporary homes.

See [Privacy and work/personal setup](docs/PRIVACY.md) for how private config is stored.
