# Privacy and work/personal split

This repo is public-safe. It must not contain secrets, company names, internal
hostnames, URLs, or tokens.

## Work flag

- `isWork` is a per-machine chezmoi data value, prompted once in `.chezmoi.toml.tmpl`.
- Default is false. Work-only behavior is gated with `{{ if .isWork }}`.

## Work overlay

- Work tooling (MCP servers, skills, internal config) lives in a separate private repo.
- That repo is cloned by a gated chezmoi external only when `isWork` is true.
- The generated `~/.agents/agents.toml` is base plus the work overlay when present.

## Rules for tracked files

- No company or internal values. Reference them through environment variables or
  the private repos.
- No literal API keys. MCP env entries list variable names only.
- `.env` is local-only and never edited by automation.
