#!/usr/bin/env python3

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
README = ROOT / "README.md"
AGENTS = ROOT / "AGENTS.md"
PACKAGES = ROOT / ".chezmoidata" / "packages.yaml"
FISH_PLUGINS = ROOT / "dot_config" / "fish" / "fish_plugins"


def parse_yaml_list(path: Path, key: str) -> list[str]:
    lines = path.read_text(encoding="utf-8").splitlines()
    items: list[str] = []
    in_section = False
    section_indent = -1

    for line in lines:
        stripped = line.strip()
        indent = len(line) - len(line.lstrip(" "))

        if not in_section:
            if stripped == f"{key}:":
                in_section = True
                section_indent = indent
            continue

        if not stripped or stripped.startswith("#"):
            continue

        if indent <= section_indent and not stripped.startswith("-"):
            break

        if stripped.startswith("-"):
            value = stripped[1:].strip()
            if " #" in value:
                value = value.split(" #", 1)[0].strip()
            value = value.strip("'\"")
            if value:
                items.append(value)

    return items


def read_fish_plugins(path: Path) -> list[str]:
    plugins: list[str] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        value = line.strip()
        if not value or value.startswith("#"):
            continue
        plugins.append(value)
    return plugins


def replace_section(text: str, marker: str, content: str) -> str:
    pattern = re.compile(
        rf"(<!-- GENERATED:{re.escape(marker)} START -->)(.*?)(<!-- GENERATED:{re.escape(marker)} END -->)",
        re.S,
    )
    match = pattern.search(text)
    if not match:
        raise ValueError(f"Missing generated marker block: {marker}")
    return (
        text[: match.start()]
        + match.group(1)
        + "\n"
        + content.rstrip()
        + "\n"
        + match.group(3)
        + text[match.end() :]
    )


def build_readme_structure() -> str:
    entries = {
        "dot_config/fish": "primary fish shell config and plugin setup",
        "dot_config/zsh": "secondary zsh compatibility config",
        "dot_config/mise": "runtime/tool versions and env injection",
        "dot_config/git": "git behavior, aliases, and signing config",
        "dot_config/brew": "Brewfile template rendered from package data",
        "dot_config/nvim": "Neovim (LazyVim) configuration",
        "dot_agents": "home-synced agent rules and skills",
        "docs": "repo documentation and privacy policy",
        "bin": "executable helper scripts",
        ".chezmoidata": "data inputs for templates and package inventory",
    }

    lines = []
    for path, desc in entries.items():
        if (ROOT / path).exists():
            lines.append(f"- `{path}`: {desc}")
    return "\n".join(lines)


def build_readme_fish_plugins() -> str:
    plugins = read_fish_plugins(FISH_PLUGINS)
    return "\n".join(f"- `{plugin}`" for plugin in plugins)


def build_agents_structure() -> str:
    dot_config = ROOT / "dot_config"
    children = sorted(p.name for p in dot_config.iterdir())
    lines = ["```text", ".", "|-- .chezmoidata/", "|-- bin/", "|-- docs/", "|-- dot_agents/", "|-- dot_config/"]
    for name in children:
        suffix = "/" if (dot_config / name).is_dir() else ""
        lines.append(f"|   |-- {name}{suffix}")
    lines.append("|-- README.md")
    lines.append("|-- AGENTS.md")
    lines.append("```")
    return "\n".join(lines)


def build_agents_packages() -> str:
    brews = parse_yaml_list(PACKAGES, "brews")
    casks = parse_yaml_list(PACKAGES, "casks")
    taps = parse_yaml_list(PACKAGES, "taps")
    key_tools = [
        tool
        for tool in ("fish", "mise", "chezmoi", "neovim", "ripgrep", "fd", "eza", "starship")
        if tool in brews
    ]
    return "\n".join(
        [
            "- Source of truth: `.chezmoidata/packages.yaml`",
            f"- Homebrew formulas: `{len(brews)}`",
            f"- Homebrew casks: `{len(casks)}`",
            f"- Homebrew taps: `{len(taps)}`",
            f"- Key tools: {', '.join(f'`{tool}`' for tool in key_tools)}",
        ]
    )


def render_files() -> dict[Path, str]:
    readme_text = README.read_text(encoding="utf-8")
    agents_text = AGENTS.read_text(encoding="utf-8")

    readme_text = replace_section(readme_text, "readme-structure", build_readme_structure())
    readme_text = replace_section(readme_text, "readme-fish-plugins", build_readme_fish_plugins())

    agents_text = replace_section(agents_text, "agents-structure", build_agents_structure())
    agents_text = replace_section(agents_text, "agents-packages", build_agents_packages())

    return {README: readme_text, AGENTS: agents_text}


def main() -> int:
    parser = argparse.ArgumentParser(description="Regenerate docs sections in README and AGENTS.")
    parser.add_argument("--check", action="store_true", help="Check whether docs are up to date.")
    args = parser.parse_args()

    rendered = render_files()
    changed = False
    for path, new_text in rendered.items():
        current = path.read_text(encoding="utf-8")
        if current != new_text:
            changed = True
            if not args.check:
                path.write_text(new_text, encoding="utf-8")
                print(f"updated {path.relative_to(ROOT)}")

    if args.check and changed:
        print("docs are out of date; run docs-gen")
        return 1

    if args.check:
        print("docs are up to date")
    return 0


if __name__ == "__main__":
    sys.exit(main())
