# Kimi Profile Adapter

Use the shared profile at `~/.ai/profile.md` as the source of truth for user
preferences.

If `~/.ai/profile.md` is unavailable, use the copy from the dotfiles checkout:
`~/dev/github.com/fiorix/dotfiles/ai/profile.md`.

## Loading Skills

When performing specialized tasks, use the shared skills under
`~/.agents/skills/`:

- **Systems Engineering:** `~/.agents/skills/syseng`
- **Architecture:** `~/.agents/skills/architect`
- **Python:** `~/.agents/skills/pythonic`
- **Rust:** `~/.agents/skills/rustacean`
- **Web Development:** `~/.agents/skills/webdev`
- **Grilling a plan:** `~/.agents/skills/grill-me`
- **Grilling a plan against docs:** `~/.agents/skills/grill-with-docs`
- **Careful verification discipline:** `~/.agents/skills/fabler`

Each skill points to the shared guide in `~/.ai/skills/` and any task-specific
references. Load only what the current task needs.
