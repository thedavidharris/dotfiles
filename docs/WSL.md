# WSL setup

## Apply these dotfiles

In Ubuntu, run the install command from the README. For this restored checkout,
use the local installer.

```bash
bash /home/david/code/dotfiles/dotfiles-wsl/install.sh
```

Before running it, install and unlock 1Password for Windows, enable the SSH
agent and CLI integration, and register your SSH public key with GitHub. Git in
WSL uses `ssh.exe` to reach the Windows 1Password agent automatically. Windows
OpenSSH must be available on the inherited PATH. If you prefer a native Linux
agent, set `ssh_command = "ssh"` under chezmoi's `[data]`.

Enter your Ubuntu password when Homebrew requests it. The installer saves a
backup, applies the dotfiles, installs packages and Fish plugins, and installs
Node. Select private agents only when you want the private repos and have a
GitHub SSH key ready. Later, `chezmoi init --prompt` can change those answers.

On an existing machine, `keepLocal` may exclude your Fish or mise configuration.
To adopt the managed versions, remove those paths from `keepLocal` before
running the installer. It backs up the existing files before applying them.

The installer uses WinGet to install the Windows 1Password CLI. Windows App Installer
provides WinGet and should be installed before starting. Approve a Windows UAC
prompt if one appears. Reopen Ubuntu afterward to refresh its inherited PATH.
The managed `op` command forwards to `op.exe`, which uses your Windows desktop app.

For commit signing, use the Windows 1Password app's **Configure Commit Signing**
action, select WSL, and paste its generated snippet into `~/.gitconfig` inside
Ubuntu. The signing key and executable path stay local.

## Windows Terminal

Use the Ubuntu profile. Set its command line to start the Homebrew Fish shell.

```text
wsl.exe -d Ubuntu --cd ~ -- /home/linuxbrew/.linuxbrew/bin/fish -l
```

Choose a Nerd Font in the profile's Appearance settings for prompt icons. Install
the font in Windows so the terminal can use it.

## WSL settings

Run `wsl --update` in PowerShell. Keep projects under `~/code` inside Ubuntu for
Linux filesystem performance. Ubuntu already has `systemd=true` configured in
`/etc/wsl.conf`. Preserve Windows interoperability for clipboard and editor tools.

For Windows 11 22H2 or newer, use WSL Settings to enable mirrored networking for
Windows/Linux localhost access and improved VPN compatibility. Keep DNS tunneling
and automatic proxy support enabled. Keep the default memory, processor, and swap
limits initially. Gradual memory reclamation is an optional setting if you want
Linux's cached memory returned to Windows gradually.

The equivalent networking and reclamation settings in `%UserProfile%\.wslconfig`
are shown below. Merge them into existing sections if you use the file directly.

```ini
[wsl2]
networkingMode=mirrored
dnsTunneling=true
autoProxy=true

[experimental]
autoMemoryReclaim=gradual
```

Save your work, then run `wsl --shutdown` in PowerShell to apply changes to WSL.
This stops all running WSL distributions. Reopen Ubuntu afterward.

## Check the result

```fish
command -s brew fish mise
brew bundle check --file=$HOME/.config/brew/Brewfile
mise current
chezmoi status
```

Sources: [Microsoft WSL settings](https://learn.microsoft.com/en-us/windows/wsl/wsl-config),
[networking](https://learn.microsoft.com/en-us/windows/wsl/networking),
[file storage](https://learn.microsoft.com/en-us/windows/wsl/filesystems), and
[Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux), and
[1Password WSL integration](https://developer.1password.com/docs/ssh/integrations/wsl/).
