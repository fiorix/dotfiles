# Gemini Profile Adapter

Use the shared profile at `~/.ai/profile.md` as the source of truth for user
preferences.

If `~/.ai/profile.md` is unavailable, use the copy from the dotfiles checkout:
`~/dev/github.com/fiorix/dotfiles/ai/profile.md`.

## Loading Skills

When performing specialized tasks, use the shared guides in `~/.ai/skills/`:

- Systems engineering: `~/.ai/skills/syseng/guide.md`
- Architecture: `~/.ai/skills/architect/guide.md`
- Python: `~/.ai/skills/pythonic/guide.md`
- Rust: `~/.ai/skills/rustacean/guide.md`
- Web development: `~/.ai/skills/webdev/guide.md`
- Grilling a plan or design: `~/.ai/skills/grill-me/guide.md`

For systems engineering work, load only the relevant subsystem reference files
from `~/.ai/skills/syseng/references/`.
