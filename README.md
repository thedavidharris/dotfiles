# David's Dotfiles

Managed with [Chezmoi](https://www.chezmoi.io/). This setup is fish-first,
with macOS zsh available for bootstrapping (no zsh dotfiles are managed).

## New Mac setup

Start in Terminal's default **zsh**. Work/personal selection is stored locally;
**the computer name is never used**. Do not copy an old Mac's chezmoi config if
you want a fresh work/personal prompt.

### 1. Install prerequisites

Finish your organization's enrollment first. Install the Command Line Tools
(or use an already configured full Xcode installation):

```sh
xcode-select --install
```

Wait for the installer to finish. Then install Homebrew if it is not already
installed, following [brew.sh](https://brew.sh/):

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Load Homebrew into this Terminal session and install the bootstrap tools:

```sh
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
else
  eval "$(/usr/local/bin/brew shellenv zsh)"
fi
brew install chezmoi
brew install --cask 1password
```

If IT already supplies 1Password, skip its cask install. The remaining formulas
and apps in `.chezmoidata/packages.yaml` are installed during the full apply.

### 2. Initialize and choose the machine role

```sh
chezmoi init https://github.com/thedavidharris/dotfiles.git
```

Answer **yes** to `Is this a work machine` on a work Mac; answer **no** on a
personal Mac. Answer **no** to the optional macOS system preferences prompt for
the initial setup. These answers survive `chezmoi init` and machine renames.

The work flag selects the private work agent overlay and the 1Password `Work`
vault. It does not change the Git email or the package list automatically.
The default Git email is the personal address in `.chezmoidata/data.yaml`.

### 3. Set up SSH before private externals

Preview and apply local dotfiles first, including SSH/1Password configuration.
This does not run scripts or fetch external repositories:

```sh
chezmoi diff --exclude scripts,externals
chezmoi apply --exclude scripts,externals
open -a 1Password
```

Sign in, unlock 1Password, and enable its SSH agent in **Settings > Developer**.
The selected vault (`Work` or `Private`) must contain an SSH key registered with
your GitHub account that can read the private repos. Enable CLI integration too
if you want to use `op`/1Password-backed tools. Confirm repository access:

```sh
git ls-remote git@github.com:thedavidharris/dot_agents.git HEAD
# Work machines only:
git ls-remote git@github.com:thedavidharris/dot_agents_work.git HEAD
```

Approve the 1Password prompts. If GitHub's host key prompt appears, verify it
against GitHub's published fingerprints before accepting. Resolve authentication
errors before continuing. The public dotfiles clone itself needs no GitHub login.

### 4. Preview and apply

```sh
chezmoi diff
chezmoi apply
exec fish
```

The after-scripts run in this order: Homebrew bundle, Fisher plugins, agent setup,
then optional macOS preferences. Agent setup installs the configured mise Node
runtime and invokes dotagents. Other language runtimes are installed in step 5.
Package/agent failures stop the apply and are retried on the next `chezmoi apply`.
If a managed app is already installed by IT and Homebrew reports a conflict,
resolve that package before rerunning; the setup does not hide bundle failures.

### 5. Finish in fish

```fish
cd ~
mise install
gh auth login
brew bundle check --file="$HOME/.config/brew/Brewfile"
chezmoi status
mise doctor
```

Install/select full Xcode separately for iOS work (the `xcodes` tools are
installed, but Xcode itself is not). Open Xcode once for its license and first-run
components, and select its Developer directory if needed. App sign-ins,
Accessibility permissions, private project credentials, and SDK downloads are
also machine-local steps.

Git commit signing uses 1Password and the public key in the Git template. Confirm
that key exists in the selected vault and is registered with GitHub for signing.
For a different work email, signing key, or vault, add local overrides as below
and reapply. Test a signed commit in a disposable repository before starting work.

To make fish your login shell (optional; run from fish):

```fish
set fish_bin (command -s fish)
grep -Fxq "$fish_bin" /etc/shells; or echo "$fish_bin" | sudo tee -a /etc/shells
chsh -s "$fish_bin"
```

Log out and back in for the login-shell change. This also lets Ghostty use fish as its default shell.

## Daily Workflow

```bash
chezmoi diff                 # Preview changes
chezmoi apply                # Apply changes
chezmoi edit ~/.config/fish/config.fish
chezmoi status               # Check source vs target drift
```

## Stack

- Shell: fish (managed); system zsh for bootstrapping
- Editor: Neovim (LazyVim)
- Prompt/theme: Starship + Catppuccin Macchiato
- Tool/runtime manager: mise
- Secrets and signing: 1Password CLI + SSH agent
- Package managers:
  - macOS: Homebrew (`packages.yaml` -> `Brewfile.tmpl`)
  - Linux: templates are supported, but package/desktop provisioning is manual

## Machine-Specific Data

`~/.config/chezmoi/chezmoi.toml` stores `isWork` and `configureMacOS` under `[data]`.
To explicitly ask again:

```fish
chezmoi init --prompt
chezmoi diff
chezmoi apply
```

A renamed Mac needs no changes. A migrated config retains the old role until you
change it. Reinitializing regenerates the config, so back up any manual overrides
and re-add them afterward. Examples of local overrides (merge into the existing
`[data]` table, do not create a second one):

```toml
[data]
isWork = true
configureMacOS = false
email = "your-work-email@example.com"
ssh_signing_key = "ssh-ed25519 YOUR_PUBLIC_KEY"

[data.onepassword]
workVault = "Your work vault name"
```

Keep private values out of this repository. For fish overrides use
`~/.config/fish/local/config.fish` or `~/.config/fish/local/conf.d/*.fish`.
Switching a previously provisioned Mac from work to personal does not delete
`~/.agents-work` or revoke credentials; new machines should start with fresh config.

The optional macOS preferences script changes system/app settings and restarts
some apps. Review it before enabling it, especially on a managed work Mac.

## Repository Snapshot

<!-- GENERATED:readme-structure START -->
- `dot_config/fish`: primary fish shell config and plugin setup
- `dot_config/mise`: runtime/tool versions and env injection
- `dot_config/git`: git behavior, aliases, and signing config
- `dot_config/brew`: Brewfile template rendered from package data
- `dot_config/nvim`: Neovim (LazyVim) configuration
- `docs`: repo documentation and privacy policy
- `bin`: executable helper scripts
- `.chezmoidata`: data inputs for templates and package inventory
<!-- GENERATED:readme-structure END -->

## Fish Plugins

<!-- GENERATED:readme-fish-plugins START -->
- `catppuccin/fish`
- `jorgebucaran/autopair.fish`
- `jorgebucaran/fisher`
- `mattmc3/macos.fish`
- `mattmc3/magic-enter.fish`
- `mattmc3/up.fish`
<!-- GENERATED:readme-fish-plugins END -->

## AI Agents

Skills and MCP servers are managed with [dotagents](https://github.com/getsentry/dotagents).
This repo holds no agent content, only the plumbing.

- `~/.agents`: private repo `dot_agents` with `AGENTS.md`, `agents.base.toml`
  (skills and MCP servers for every machine)
- `~/.agents-work`: private repo `dot_agents_work` with `agents.work.toml`,
  cloned only when `isWork` is true
- `~/.agents/agents.toml`: generated by `.chezmoiscripts/run_after_30-agents.sh.tmpl` from base
  plus work, then `dotagents install` runs. Never edit it or run `dotagents add`.

Add or change a skill or MCP server:

```bash
$EDITOR ~/.agents/agents.base.toml   # work-only: ~/.agents-work/agents.work.toml
chezmoi apply                        # recomposes agents.toml and installs
```

```toml
[[skills]]
name = "swiftui-pro"
source = "twostraws/SwiftUI-Agent-Skill"   # owner/repo; add path = "dir" if nested

[[mcp]]
name = "example"
url = "https://example.com/mcp"
```

Find a skill's `path` with `gh repo clone <owner/repo> /tmp/x -- --depth 1` and
`git ls-files | grep SKILL.md`. Update skills to latest with
`npx -y @sentry/dotagents@3 --user install`. Check health with `... doctor`.
Commit and push the private repo after editing. See `docs/PRIVACY.md`.

## Keep Docs Updated

```bash
python3 scripts/docs-gen.py
```

`docs-gen` refreshes generated sections in `README.md` and `AGENTS.md`.

## Validate changes

With Python 3.11+, chezmoi, fish, and shellcheck installed:

```fish
python3 scripts/check-bootstrap.py
python3 scripts/docs-gen.py --check
```

The checks use temporary homes, render macOS/Linux and work/personal profiles,
and mock package/agent installation. They never install dotfiles into your real
home or run macOS preference changes. A real Mac is still required to verify
Homebrew casks, 1Password authentication, Xcode, and system preferences end to end.
