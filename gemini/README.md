# Gemini CLI Configuration

This directory contains Gemini-specific configurations and resources, mirroring the
structure of `claude/` and `codex/`.

## Structure

- `README.md`: This file.
- `GEMINI.md`: Global Gemini adapter installed to `~/.gemini/GEMINI.md`.
- `commands/*.toml`: Gemini custom command adapters installed to
  `~/.gemini/commands/`.
- `../GEMINI.md`: Root-level project adapter for this dotfiles checkout.

## Shared Skills

Gemini CLI loads global context from `~/.gemini/GEMINI.md` and project context
from repository `GEMINI.md` files. The custom commands mirror Claude's slash
commands and point at the same shared guides in `~/.ai/skills/`.
