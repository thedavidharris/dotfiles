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

Answer **yes** to `Is this a work machine` on a work Mac, then enter your **work
email address**. On a personal Mac, answer **no**; no work email is requested.
Answer **no** to the optional macOS system preferences prompt for
the initial setup. These answers survive `chezmoi init` and machine renames.

The work flag selects the private work agent overlay, the work vault for both
1Password SSH and fnox, and the saved work email. Git uses this selected email;
fish exports it as `EMAIL` and, on work machines, `WORK_EMAIL`. Agent installation
receives the same variables even when bootstrapping from zsh. Work tools and
private agent configs can reference `WORK_EMAIL` rather than hardcoding an address.
The shared package list is unchanged by the role. Personal machines use
`personalEmail` from `.chezmoidata/data.yaml` unless locally overridden.

### 3. Set up SSH before private externals

Preview and apply local dotfiles first, including SSH/1Password configuration.
This does not run scripts or fetch external repositories:

```sh
chezmoi diff --exclude scripts --override-data '{"offline":true}'
chezmoi apply --exclude scripts --override-data '{"offline":true}'
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
For a different work email, run `chezmoi init --prompt` and reapply. For a different
signing key or vault, add local overrides as below and reapply. Test a signed
commit in a disposable repository before starting work.

To make fish your login shell (optional; run from fish):

```fish
set fish_bin (command -s fish)
grep -Fxq "$fish_bin" /etc/shells; or echo "$fish_bin" | sudo tee -a /etc/shells
chsh -s "$fish_bin"
```

Log out and back in for the login-shell change. This also lets Ghostty use fish as its default shell.

## Ubuntu on WSL 2

Run these steps inside Ubuntu, from your Linux home directory. The same Homebrew
package list provides command-line tools on macOS and WSL. Mac apps, preferences,
and Xcode tools are omitted on WSL.

1. Install Homebrew at its [standard Linux location](https://docs.brew.sh/Homebrew-on-Linux).
   On a fresh Ubuntu install, use `sudo apt-get install build-essential procps curl file git`
   for Homebrew's system prerequisites. The Homebrew installer may ask for your
   Ubuntu password to create `/home/linuxbrew/.linuxbrew`.
2. In Bash, run:

   ```bash
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
   brew install chezmoi
   chezmoi init https://github.com/thedavidharris/dotfiles.git
   ```

   If you already have a checkout, use `chezmoi --source /path/to/dotfiles init`
   and the same `--source` for subsequent commands, or set `sourceDir` in the
   local chezmoi config. Choose the appropriate machine role when prompted.
3. Run `chezmoi diff --exclude scripts` and review existing files before applying.
   To keep a file under your own control, add its home-relative path to
   `keepLocal` under `[data]` in your local chezmoi config. For example:

   ```toml
   keepLocal = [".config/fish/config.fish", ".config/mise/config.toml"]
   ```

   Run `chezmoi apply` to install packages and Fish plugins. Add the
   `brew shellenv` line above to your Bash startup file if you want Brew
   packages on Bash's path. The managed Fish startup files find Homebrew
   automatically; run `fish` to try them without changing your login shell.
   Confirm packages with `brew bundle check --file="$HOME/.config/brew/Brewfile"`.

Private agent repos and their installer are opt-in on Linux. Once you have
GitHub SSH access, set `installAgents = true` under `[data]` to enable them.
Linux uses your normal SSH agent by default and leaves Git signing to your local
configuration. For chezmoi-managed SSH signing, set `ssh_signing_key` and, if
needed, `ssh_signing_program` and `ssh_agent_sock` under `[data]`. Configure
1Password CLI separately if you use the fnox 1Password provider.

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
- Packages: Homebrew on macOS and Linux/WSL (`packages.yaml` -> `Brewfile.tmpl`)

## Machine-Specific Data

`~/.config/chezmoi/chezmoi.toml` stores `isWork`, `workEmail`, `personalEmail`,
the selected `email`, and `configureMacOS` under `[data]`.
To explicitly ask again:

```fish
chezmoi init --prompt
chezmoi diff
chezmoi apply
```

A renamed Mac needs no changes. A migrated config retains the old role until you
change it. Reinitializing preserves saved emails and manual `[data]` overrides,
including nested tables. It regenerates other config sections, so back up any
custom settings outside `[data]`. The active `email` is recalculated for the
selected role; change `workEmail` or `personalEmail`, rather than editing `email`.
Examples of local overrides (merge into the existing
`[data]` table, do not create a second one):

```toml
[data]
isWork = true
configureMacOS = false
workEmail = "your-work-email@example.com"
personalEmail = "your-personal-email@example.com"
ssh_signing_key = "ssh-ed25519 YOUR_PUBLIC_KEY"

[data.onepassword]
workVault = "Your work vault name"
```

After manually editing an email, run `chezmoi init` then `chezmoi apply`, and
start a new fish shell. Switching to personal restores the personal email and
removes the exported `WORK_EMAIL` from new fish shells; the saved work address is
retained locally for a future switch back. Previously open shells retain their
old environment until restarted. These variables do not sign into accounts or
rewrite independently managed private repositories.

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
