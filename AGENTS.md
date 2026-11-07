# AGENTS.md

- This is a chezmoi source repo for macOS and Linux/WSL. Keep this file repo-local
  and prefer Fish for shell examples.
- Update `.chezmoidata/packages.yaml` when changing Homebrew packages. The
  Brewfile is rendered from it.
- Use `.email` in templates and `WORK_EMAIL` for work integrations. Keep work
  addresses, company details, and secrets out of tracked files. Leave `.env` alone.
- Edit agent config in the private repos. `~/.agents/agents.toml` is generated
  from the base config and the work overlay. Avoid `dotagents add`.
- Validate bootstrap changes with `python3 scripts/check-bootstrap.py`.
