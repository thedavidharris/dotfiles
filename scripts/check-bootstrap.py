#!/usr/bin/env python3
"""Offline regression checks; use only temporary homes and mocked installers."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import tomllib

ROOT = Path(__file__).resolve().parent.parent
CHEZMOI = shutil.which("chezmoi")
PERSONAL_EMAIL = "davidaharris@outlook.com"
WORK_EMAIL = "david+work@example.test"
for tool in ("chezmoi", "fish", "shellcheck", "ruby"):
    if not shutil.which(tool):
        raise SystemExit(f"Missing test dependency: {tool}")


def run(args, *, env=None, input=None, ok=True):
    result = subprocess.run(args, cwd=ROOT, env=env, input=input, text=True,
                            capture_output=True, timeout=45)
    if ok and result.returncode:
        raise AssertionError(f"{args}:\n{result.stdout}\n{result.stderr}")
    return result


def executable(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("#!/bin/bash\nset -eu\n" + content)
    path.chmod(0o755)


with tempfile.TemporaryDirectory(prefix="dotfiles-check-") as directory:
    temp = Path(directory)
    for platform, arch in (("darwin", "arm64"), ("darwin", "amd64"), ("linux", "amd64")):
        for work in (False, True):
            case = temp / f"{platform}-{arch}-{work}"
            home = case / "home"
            home.mkdir(parents=True)
            config = case / "chezmoi.toml"
            env = dict(os.environ, HOME=str(home), XDG_CONFIG_HOME=str(home / ".config"),
                       XDG_CACHE_HOME=str(home / ".cache"), XDG_DATA_HOME=str(home / ".local/share"),
                       XDG_STATE_HOME=str(home / ".local/state"))
            override = {"chezmoi": {"os": platform, "arch": arch, "hostname": "brand-new-mac"}}
            command = [CHEZMOI, "--source", str(ROOT), "--destination", str(home),
                       "--config", str(config), "--cache", str(case / "cache"),
                       "--persistent-state", str(case / "state.boltdb"), "--no-tty",
                       "--override-data", json.dumps(override)]
            prompts = (f"Is this a work machine={str(work).lower()},Apply macOS system preferences (optional)=false,"
                       "Install private agent configs (requires GitHub SSH)=false")
            run(command + ["init", "--promptBool", prompts] + (["--promptString", f"Work email address={WORK_EMAIL}"] if work else []), env=env, input="")
            data = tomllib.loads(config.read_text())["data"]
            assert data["isWork"] is work and data["configureMacOS"] is False
            assert data["installAgents"] is False
            assert tomllib.loads(config.read_text())["sourceDir"] == str(ROOT)
            assert data["email"] == (WORK_EMAIL if work else PERSONAL_EMAIL)
            assert data["personalEmail"] == PERSONAL_EMAIL
            assert ("workEmail" in data) is work
            # Re-init must not ask again, including after a hostname change.
            changed_host = command.copy()
            changed_host[-1] = json.dumps({"chezmoi": {**override["chezmoi"], "hostname": "renamed-mac"}})
            run(changed_host + ["init"], env=env, input="")
            assert tomllib.loads(config.read_text())["data"] == data
            # Explicit --prompt can change a role copied from another machine.
            alternate = prompts.replace(f"machine={str(work).lower()}", f"machine={str(not work).lower()}")
            run(command + ["init", "--prompt", "--promptBool", alternate, "--promptString", f"Work email address={WORK_EMAIL}"], env=env)
            assert tomllib.loads(config.read_text())["data"]["isWork"] is not work
            assert tomllib.loads(config.read_text())["data"]["email"] == (PERSONAL_EMAIL if work else WORK_EMAIL)
            run(command + ["init", "--prompt", "--promptBool", prompts, "--promptString", f"Work email address={WORK_EMAIL}"], env=env)

            def render(path, extra=None):
                cmd = command if extra is None else command[:-1] + [json.dumps({**override, **extra})]
                return run(cmd + ["execute-template", "--file", str(ROOT / path)], env=env).stdout

            # Render every template without fetching externals or executing scripts.
            for template in ROOT.rglob("*.tmpl"):
                if template.name == ".chezmoi.toml.tmpl" or ".git" in template.parts:
                    continue
                rendered = render(template.relative_to(ROOT))
                if ".sh.tmpl" in template.name and rendered.strip():
                    run(["bash", "-n"], input=rendered)
                    run(["shellcheck", "--severity=error", "--shell=bash", "-"], input=rendered)
            macos = platform == "darwin"
            externals = tomllib.loads(render(".chezmoiexternal.toml.tmpl"))
            assert ".agents" not in externals
            assert ".agents-work" not in externals
            assert (".hammerspoon/Spoons/SpoonInstall.spoon" in externals) is macos
            opted_in = tomllib.loads(render(".chezmoiexternal.toml.tmpl", {"installAgents": True}))
            assert ".agents" in opted_in and (".agents-work" in opted_in) is work
            assert not render(".chezmoiscripts/run_after_30-agents.sh.tmpl").strip()
            # Evaluate the real Brewfile with a tiny Homebrew DSL on both platforms.
            ruby = """
module OS
  def self.mac?; ARGV[1] == "darwin"; end
end
def brew(name); puts "brew #{name}"; end
def cask(name); puts "cask #{name}"; end
load ARGV[0]
"""
            brewfile = run(["ruby", "-e", ruby, str(ROOT / "dot_config/brew/Brewfile"), platform]).stdout.splitlines()
            assert "brew fish" in brewfile and "brew chezmoi" in brewfile
            assert "cask 1password" not in brewfile
            assert ("cask 1password-cli" in brewfile) is macos
            assert ("brew coreutils" in brewfile) is macos
            assert brewfile.count("brew nmap") == brewfile.count("brew pkl") == 1
            assert tomllib.loads((ROOT / "dot_config/mise/config.toml").read_text())["tools"] == {"node": "lts"}
            agent_config = tomllib.loads(render("dot_config/private_1Password/private_ssh/private_agent.toml.tmpl"))
            assert agent_config["ssh-keys"][0]["vault"] == ("Work" if work else "Private")
            fnox_config = tomllib.loads(render("dot_config/fnox/config.toml.tmpl"))
            assert fnox_config["providers"]["onepass"]["vault"] == ("Work" if work else "Private")
            if work:
                vault_override = {"onepassword": {"workVault": "Custom work vault"}}
                assert tomllib.loads(render("dot_config/fnox/config.toml.tmpl", vault_override))["providers"]["onepass"]["vault"] == "Custom work vault"
                assert tomllib.loads(render("dot_config/private_1Password/private_ssh/private_agent.toml.tmpl", vault_override))["ssh-keys"][0]["vault"] == "Custom work vault"
            macos_path = ".chezmoiscripts/run_onchange_after_90-configure-macos.sh.tmpl"
            assert not render(macos_path).strip()
            assert bool(render(macos_path, {"configureMacOS": True}).strip()) is (platform == "darwin")
            if platform == "darwin":
                run(["bash", "-n"], input=render(macos_path, {"configureMacOS": True}))

            # Apply local files twice without network access or installers.
            offline = command[:-1] + [json.dumps({**override, "offline": True})]
            run(offline + ["apply", "--exclude", "scripts"], env=env)
            assert (home / ".ssh/config").is_file()
            run(offline + ["apply", "--exclude", "scripts"], env=env)
            run(offline + ["verify", "--exclude", "scripts"], env=env)
            assert (home / "docs/PRIVACY.md").is_file()
            assert not (home / "scripts").exists()
            assert not (home / "install.sh").exists()
            assert not (home / "AGENTS.md").exists()
            assert not (home / ".github").exists()
            assert (home / ".hammerspoon/init.lua").exists() is macos
            assert (home / ".config/1Password").exists() is macos
            for helper in ("cleanup-system", "copy-sha256", "dict", "ds-destroy",
                           "macho-info", "ocr", "sleepybear", "speak"):
                assert (home / "bin" / helper).is_file()
            assert ("IdentityAgent" in (home / ".ssh/config").read_text()) is macos
            git_config = home / ".config/git/config"
            run(["git", "config", "--file", str(git_config), "--list"])
            assert run(["git", "config", "--file", str(git_config), "user.email"]).stdout.strip() == (WORK_EMAIL if work else PERSONAL_EMAIL)
            assert ("op-ssh-sign" in git_config.read_text()) is macos
            assert ("fsmonitor = true" in git_config.read_text()) is macos
            assert ("sshCommand = ssh.exe" in git_config.read_text()) is (not macos and bool(env.get("WSL_DISTRO_NAME")))
            identity = render("dot_config/fish/conf.d/identity.fish.tmpl")
            run(["fish", "--no-config", "--no-execute"], input=identity)
            observed = run(["fish", "--no-config"], env=dict(env, WORK_EMAIL="stale@example.test"),
                           input=identity + '\nprintf "%s\\n" "$EMAIL" "$WORK_EMAIL"\n').stdout.splitlines()
            expected = [WORK_EMAIL, WORK_EMAIL] if work else [PERSONAL_EMAIL, ""]
            assert observed == expected
            print(f"PASS: {platform}/{arch}, {'work' if work else 'personal'} init, render, staged apply, verify")

            if not macos:
                local_fish = home / ".config/fish/config.fish"
                local_fish.write_text("# existing local config\n")
                preserved = command[:-1] + [json.dumps({**override, "offline": True, "keepLocal": [".config/fish/config.fish"]})]
                run(preserved + ["apply", "--exclude", "scripts"], env=env)
                assert local_fish.read_text() == "# existing local config\n"
                if not work:
                    mock = case / "mock-bin"
                    executable(mock / "brew", 'printf "%s\\n" "$@" > "$MOCK_BREW"\nexit "${BREW_EXIT:-0}"\n')
                    mock_env = dict(env, PATH=f"{mock}:{env['PATH']}", MOCK_BREW=str(case / "brew.log"))
                    bundle = render(".chezmoiscripts/run_after_10-brew-bundle.sh.tmpl")
                    assert run(["bash"], env=dict(mock_env, BREW_EXIT="23"), input=bundle, ok=False).returncode == 23
                    run(["bash"], env=mock_env, input=bundle)
                    assert Path(mock_env["MOCK_BREW"]).read_text().splitlines() == [
                        "bundle", "check", "--no-upgrade", f"--file={home}/.config/brew/Brewfile",
                    ]
                    # A Windows CLI install failure must stop apply and remain retryable.
                    wsl_script = run(command + ["execute-template", "--file",
                                              str(ROOT / ".chezmoiscripts/run_after_25-op-wsl.sh.tmpl")],
                                     env=dict(env, WSL_DISTRO_NAME="Ubuntu")).stdout
                    executable(mock / "winget.exe", 'echo "$1" >> "$MOCK_WINGET_LOG"\n'
                               'if [[ "$1" = list ]]; then exit 20; fi\nexit "${WINGET_EXIT:-0}"\n')
                    cli_env = dict(env, PATH=str(mock), MOCK_WINGET_LOG=str(case / "winget.log"))
                    assert run(["/bin/bash"], env=dict(cli_env, WINGET_EXIT="17"),
                               input=wsl_script, ok=False).returncode == 17
                    run(["/bin/bash"], env=cli_env, input=wsl_script)
                    assert Path(cli_env["MOCK_WINGET_LOG"]).read_text().splitlines() == [
                        "list", "install", "list", "install",
                    ]
                    executable(mock / "op.exe", "exit 0\n")
                    run(["/bin/bash"], env=cli_env, input=wsl_script)
                    assert len(Path(cli_env["MOCK_WINGET_LOG"]).read_text().splitlines()) == 4

            if platform != "darwin" or arch != "arm64" or not work:
                continue

            # Re-init preserves arbitrary local data overrides, including nested tables.
            with config.open("a") as out:
                out.write('\n[data.onepassword]\nworkVault = "Custom vault"\n[data.tools]\neditor = "vim"\n')
            run(command + ["init"], env=env, input="")
            saved = tomllib.loads(config.read_text())["data"]
            assert saved["onepassword"]["workVault"] == "Custom vault"
            assert saved["tools"]["editor"] == "vim"
            # Legacy personal email overrides survive migration and work/personal switches.
            config.write_text('[data]\nisWork = false\nconfigureMacOS = false\ninstallAgents = false\nemail = "personal@example.test"\n')
            run(command + ["init"], env=env, input="")
            assert tomllib.loads(config.read_text())["data"]["personalEmail"] == "personal@example.test"
            run(command + ["init", "--prompt", "--promptBool", prompts,
                           "--promptString", f"Work email address={WORK_EMAIL}"], env=env)
            # Blank and malformed answers fail before writing a new configuration.
            for invalid in ("", "not-an-email", "name@", "two words@example.test"):
                bad = run(command + ["init", "--prompt", "--promptBool", prompts,
                                     "--promptString", f"Work email address={invalid}"], env=env, ok=False)
                assert bad.returncode != 0 and "non-empty work email address" in bad.stderr
                assert tomllib.loads(config.read_text())["data"]["workEmail"] == WORK_EMAIL
            # Valid email punctuation must remain literal in shell templates.
            unusual = "david.o'neil+$cash@example.test"
            identity = render("dot_config/fish/conf.d/identity.fish.tmpl",
                              {"email": unusual, "workEmail": unusual})
            observed = run(["fish", "--no-config"], env=env,
                           input=identity + '\nprintf "%s\\n" "$EMAIL" "$WORK_EMAIL"\n').stdout.splitlines()
            assert observed == [unusual, unusual]
            print("PASS: email prompts, role switches, validation, literal shell values, override migration")

            mock = case / "mock-bin"
            node_bin = case / "node/bin"
            log = case / "npx.log"
            executable(mock / "brew", 'exit "${BREW_EXIT:-0}"\n')
            executable(mock / "mise", 'if [[ "$1" = exec ]]; then shift 3; exec "$MOCK_NODE/bin/$1" "${@:2}"; fi\n')
            executable(node_bin / "npx", 'echo install >> "$MOCK_LOG"\nprintf "%s\\n%s\\n" "$EMAIL" "${WORK_EMAIL-}" > "$MOCK_IDENTITY"\nexit "${NPX_EXIT:-0}"\n')
            mock_env = dict(env, PATH=f"{mock}:{env['PATH']}", MOCK_NODE=str(node_bin.parent), MOCK_LOG=str(log), MOCK_IDENTITY=str(case / "agent-identity"))
            agents = home / ".agents"
            agents.mkdir()
            (agents / "agents.base.toml").write_text('[[skills]]\nname = "base"\n')
            overlay = home / ".agents-work"
            overlay.mkdir()
            (overlay / "agents.work.toml").write_text('[[skills]]\nname = "work"\n')
            script = render(".chezmoiscripts/run_after_30-agents.sh.tmpl", {"installAgents": True})
            marker = home / ".cache/dotfiles/agents-v3-installed.toml"
            assert run(["bash"], env=dict(mock_env, NPX_EXIT="17"), input=script, ok=False).returncode == 17
            assert not marker.exists()
            run(["bash"], env=mock_env, input=script)
            assert marker.exists() and len(log.read_text().splitlines()) == 2
            assert Path(mock_env["MOCK_IDENTITY"]).read_text().splitlines() == [WORK_EMAIL, WORK_EMAIL]
            run(["bash"], env=mock_env, input=script)
            assert len(log.read_text().splitlines()) == 2
            (overlay / "agents.work.toml").write_text('[[skills]]\nname = "changed-work"\n')
            assert run(["bash"], env=dict(mock_env, NPX_EXIT="17"), input=script, ok=False).returncode == 17
            run(["bash"], env=mock_env, input=script)
            assert len(log.read_text().splitlines()) == 4
            assert "changed-work" in marker.read_text()
            (overlay / "agents.work.toml").unlink()
            assert run(["bash"], env=mock_env, input=script, ok=False).returncode != 0
            (overlay / "agents.work.toml").write_text('[[skills]]\nname = "changed-work"\n')
            new_email = "new-work@example.test"
            changed_identity = render(".chezmoiscripts/run_after_30-agents.sh.tmpl",
                                      {"email": new_email, "workEmail": new_email, "installAgents": True})
            run(["bash"], env=mock_env, input=changed_identity)
            assert len(log.read_text().splitlines()) == 5
            assert Path(mock_env["MOCK_IDENTITY"]).read_text().splitlines() == [new_email, new_email]
            run(["bash"], env=mock_env, input=changed_identity)
            assert len(log.read_text().splitlines()) == 5
            personal_script = render(".chezmoiscripts/run_after_30-agents.sh.tmpl",
                                     {"isWork": False, "email": PERSONAL_EMAIL, "installAgents": True})
            run(["bash"], env=dict(mock_env, WORK_EMAIL="stale@example.test"), input=personal_script)
            assert Path(mock_env["MOCK_IDENTITY"]).read_text().splitlines() == [PERSONAL_EMAIL, ""]
            bundle = render(".chezmoiscripts/run_after_10-brew-bundle.sh.tmpl")
            assert run(["bash"], env=dict(mock_env, BREW_EXIT="23"), input=bundle, ok=False).returncode == 23
            # Exercise fish initialization and error propagation with an offline Fisher stub.
            executable(mock / "curl", "cat <<'FISH'\nfunction fisher\n    echo $fisher_path > $MOCK_FISH_PATH\n    return $FISHER_EXIT\nend\nFISH\n")
            fish_env = dict(mock_env, MOCK_FISH_PATH=str(case / "fisher-path"), FISHER_EXIT="0")
            fish_script = render(".chezmoiscripts/run_onchange_after_20-configure-fish.sh.tmpl")
            run(["bash"], env=fish_env, input=fish_script)
            assert Path(fish_env["MOCK_FISH_PATH"]).read_text().strip() == str(home / ".config/fish/.fisher")
            assert run(["bash"], env=dict(fish_env, FISHER_EXIT="1"), input=fish_script, ok=False).returncode != 0
            print("PASS: agent retries/no-op/missing-overlay, brew failure, Fisher path/failure")

    # Exercise the public installer with real chezmoi and offline package stubs.
    bootstrap_home = temp / "installer-home"
    bootstrap_home.mkdir()
    prefix = temp / "brew-prefix"
    tools = prefix / "bin"
    tools.mkdir(parents=True)
    (tools / "chezmoi").symlink_to(CHEZMOI)
    executable(tools / "op.exe", "exit 0\n")
    executable(tools / "brew", 'if [[ "$1" = --prefix ]]; then echo "$MOCK_PREFIX"; fi\n')
    executable(tools / "mise", 'echo "$*" >> "$MOCK_MISE_LOG"\n')
    executable(tools / "curl", "cat <<'FISH'\nfunction fisher\n    return 0\nend\nFISH\n")
    bootstrap_config = bootstrap_home / ".config/chezmoi/chezmoi.toml"
    bootstrap_config.parent.mkdir(parents=True)
    bootstrap_config.write_text(f'sourceDir = {json.dumps(str(ROOT))}\numask = 63\n'
                                '[data]\nisWork = false\ninstallAgents = false\n'
                                'configureMacOS = false\noffline = true\n')
    original_fish = bootstrap_home / ".config/fish/config.fish"
    original_fish.parent.mkdir(parents=True)
    original_fish.write_text("# existing user configuration\n")
    bashrc = bootstrap_home / ".bashrc"
    bashrc.write_text("# existing Bash startup\n")
    bootstrap_env = dict(os.environ, HOME=str(bootstrap_home), PATH=f"{tools}:{os.environ['PATH']}",
                         XDG_CONFIG_HOME=str(bootstrap_home / ".config"),
                         XDG_CACHE_HOME=str(bootstrap_home / ".cache"),
                         XDG_DATA_HOME=str(bootstrap_home / ".local/share"),
                         XDG_STATE_HOME=str(bootstrap_home / ".local/state"),
                         MOCK_PREFIX=str(prefix), MOCK_MISE_LOG=str(temp / "mise-installs.log"))
    run(["bash", str(ROOT / "install.sh")], env=bootstrap_env)
    backups = list((bootstrap_home / ".local/state/dotfiles/backups").iterdir())
    assert len(backups) == 1
    assert (backups[0] / ".config/fish/config.fish").read_text() == "# existing user configuration\n"
    assert (backups[0] / "chezmoi.toml").is_file()
    assert original_fish.read_text() == (ROOT / "dot_config/fish/config.fish").read_text()
    assert bashrc.read_text() == "# existing Bash startup\n"
    saved = tomllib.loads(bootstrap_config.read_text())
    assert saved["sourceDir"] == str(ROOT) and saved["umask"] == 63
    run(["bash", str(ROOT / "install.sh")], env=bootstrap_env)
    assert not (bootstrap_home / ".agents").exists()
    assert (temp / "mise-installs.log").read_text().splitlines() == ["install", "install"]
    # A real Fish startup reads the installed configuration without downloading plugins.
    run(["fish", "--private", "--interactive", "--command", "type -q clipcopy"], env=bootstrap_env)
    print("PASS: installer backups, existing source and permissions, reruns, Fish startup")

    # A native Windows profile must have no managed targets, even with agents enabled.
    windows = command[:-1] + [json.dumps({"chezmoi": {"os": "windows"}, "installAgents": True})]
    assert not run(windows + ["managed"], env=env).stdout.strip()
    for path in (ROOT / "install.sh", ROOT / "bin/executable_brew-bundle",
                 ROOT / "bin/executable_edit-packages", ROOT / "bin/executable_agents-update",
                 ROOT / "bin/executable_op"):
        run(["bash", "-n", str(path)])
    run(["shellcheck", "--severity=warning", str(ROOT / "install.sh")])
    for path in (ROOT / "dot_config/fish").rglob("*.fish"):
        run(["fish", "--no-config", "--no-execute", str(path)])
    print("PASS: fish syntax")
