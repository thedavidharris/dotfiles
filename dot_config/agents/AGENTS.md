# AI Agent Guidelines

## Git Operations

- Delete unused files only when your changes make them irrelevant; revert only your own work
- **Never delete files to fix lint/type errors without asking first**
- Never edit `.env` or environment files
- Always check `git status` before commits
- Keep commits atomic with explicit file paths
- Quote paths with brackets/parentheses in git commands
- Use `GIT_EDITOR=:` for non-interactive rebases
- Never run destructive operations (`git reset --hard`, `git restore` to old commits) without explicit approval

## Modern CLI Tools

Prefer modern alternatives: `fd` over `find`, `rg` over `grep`, `bat` over `cat`, `eza` over `ls`.

**Important**: `find` and `grep` are NOT aliased. Use `fd` and `rg` directly, or shortcuts like `fdi` (case-insensitive fd), `rgi` (case-insensitive rg), `rgu` (unrestricted rg).

For complex `find` expressions with `-exec` or `-mtime`, use real `find`. For POSIX scripts, use `command grep`.
