# Dotfiles Project Adapter

This repository contains shared configuration for Claude, Codex, Gemini, and Kimi.

## Shared Resources

- `ai/profile.md` — user preferences, installed to `~/.ai/profile.md`.
- `ai/skills/` — shared skill guides, installed to `~/.ai/skills/`.
- `agents/skills/` — tool-neutral skill adapters, installed to `~/.agents/skills/`.

## Per-Agent Adapters

- `claude/` — Claude Code command adapters.
- `codex/` — Codex user-level `AGENTS.md`.
- `gemini/` — Gemini global and command adapters.
- `kimi/` — Kimi user-level `AGENTS.md`.

Run `./install.sh` to install or update everything.
