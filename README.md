# David's Dotfiles

Managed with [Chezmoi](https://www.chezmoi.io/). This setup is fish-first,
with zsh kept as a secondary shell.

## Quick Start

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
chezmoi init --apply https://github.com/thedavidharris/dotfiles.git
exec fish
```

## Daily Workflow

```bash
chezmoi diff                 # Preview changes
chezmoi apply                # Apply changes
chezmoi edit ~/.config/fish/config.fish
chezmoi status               # Check source vs target drift
```

## Stack

- Shell: fish (primary), zsh (secondary)
- Editor: Neovim (LazyVim)
- Prompt/theme: Starship + Catppuccin Macchiato
- Tool/runtime manager: mise
- Secrets and signing: 1Password CLI + SSH agent
- Package manager: Homebrew (`packages.yaml` -> `Brewfile.tmpl`)

## Repository Snapshot

<!-- GENERATED:readme-structure START -->
- `dot_config/fish`: primary fish shell config and plugin setup
- `dot_config/zsh`: secondary zsh compatibility config
- `dot_config/mise`: runtime/tool versions and env injection
- `dot_config/git`: git behavior, aliases, and signing config
- `dot_config/brew`: Brewfile template rendered from package data
- `dot_config/nvim`: Neovim (LazyVim) configuration
- `dot_agents`: home-synced agent rules and skills
- `docs`: repo documentation and privacy policy
- `bin`: executable helper scripts
- `.chezmoidata`: data inputs for templates and package inventory
<!-- GENERATED:readme-structure END -->

## Fish Plugins

<!-- GENERATED:readme-fish-plugins START -->
- `catppuccin/fish`
- `franciscolourenco/done`
- `jorgebucaran/autopair.fish`
- `jorgebucaran/fisher`
- `mattmc3/macos.fish`
- `mattmc3/magic-enter.fish`
- `mattmc3/up.fish`
<!-- GENERATED:readme-fish-plugins END -->

## Privacy

See `docs/PRIVACY.md` for the current privacy/work-config policy and local-only
patterns for internal endpoints and credentials.

## Keep Docs Updated

```bash
docs-gen
docs-lint
```

`docs-gen` refreshes generated sections in `README.md` and `AGENTS.md`.
`docs-lint` checks that generated docs are current and referenced paths exist.
