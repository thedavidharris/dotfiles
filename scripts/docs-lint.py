#!/usr/bin/env python3

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
README = ROOT / "README.md"
AGENTS = ROOT / "AGENTS.md"
DOCS = [README, AGENTS]
REQUIRED_MARKERS = [
    "readme-structure",
    "readme-fish-plugins",
    "agents-structure",
    "agents-packages",
]


def path_candidates(text: str) -> set[str]:
    candidates: set[str] = set()
    root_files = {"AGENTS.md", "README.md", ".gitignore", ".chezmoiignore", "chezmoi.toml.tmpl"}
    for token in re.findall(r"`([^`\n]+)`", text):
        if not re.fullmatch(r"[A-Za-z0-9._/\-]+", token):
            continue
        if "/" not in token and token not in root_files:
            continue
        if token.startswith("http"):
            continue
        if token.startswith("~"):
            continue
        if token in root_files or token.startswith("bin/") or token.startswith("dot_") or token.startswith("docs/") or token.startswith(".chezmoidata/"):
            candidates.add(token)
    return candidates


def validate_markers() -> list[str]:
    errors: list[str] = []
    text = (README.read_text(encoding="utf-8") + "\n" + AGENTS.read_text(encoding="utf-8"))
    for marker in REQUIRED_MARKERS:
        start = f"<!-- GENERATED:{marker} START -->"
        end = f"<!-- GENERATED:{marker} END -->"
        if start not in text or end not in text:
            errors.append(f"missing generated marker block: {marker}")
    return errors


def validate_paths() -> list[str]:
    errors: list[str] = []
    for doc in DOCS:
        text = doc.read_text(encoding="utf-8")
        for candidate in sorted(path_candidates(text)):
            target = ROOT / candidate
            if not target.exists():
                errors.append(f"{doc.name}: missing referenced path `{candidate}`")
    return errors


def run_docs_check() -> list[str]:
    errors: list[str] = []
    proc = subprocess.run(
        [sys.executable, str(ROOT / "bin" / "executable_docs-gen"), "--check"],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=False,
    )
    if proc.returncode != 0:
        output = (proc.stdout + proc.stderr).strip()
        errors.append(output or "docs-gen --check failed")
    return errors


def main() -> int:
    errors: list[str] = []
    errors.extend(validate_markers())
    errors.extend(validate_paths())
    errors.extend(run_docs_check())

    if errors:
        for error in errors:
            print(f"error: {error}")
        return 1

    print("docs lint passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
