# Gemini Profile Adapter

Use the shared profile at `~/.ai/profile.md` as the source of truth for user
preferences.

If `~/.ai/profile.md` is unavailable, use the copy from the dotfiles checkout:
`~/dev/github.com/fiorix/dotfiles/ai/profile.md`.

## Repository Context

This repository houses configuration for multiple AI agents: Claude, Codex, and Gemini.
The shared behavior and skills are defined in the `ai/` directory.

## Loading Skills

When performing specialized tasks, refer to the guides in `~/.ai/skills/`:

- **Systems Engineering:** `~/.ai/skills/syseng/guide.md`
- **Architectural Design:** `~/.ai/skills/architect/guide.md`
- **Python Development:** `~/.ai/skills/pythonic/guide.md`
- **Rust Development:** `~/.ai/skills/rustacean/guide.md`
- **Web Development:** `~/.ai/skills/webdev/guide.md`

Use these files to inform your strategy and execution for relevant tasks.
