#!/bin/sh
set -eu
cd "$(dirname "$0")"

install_dir() {
  src=$1
  dst=$2
  rm -rf "$dst"
  mkdir -p "$dst"
  cp -R "$src"/. "$dst"/
}

old_claude=0
if [ -f "$HOME/.claude/CLAUDE.md" ] && ! grep -q "Claude Profile Adapter" "$HOME/.claude/CLAUDE.md"; then
  old_claude=1
fi
if [ -d "$HOME/.claude/commands" ]; then
  for f in "$HOME"/.claude/commands/*.md; do
    [ -e "$f" ] || continue
    if ! grep -q "Shared Claude Command Adapter" "$f"; then
      old_claude=1
      break
    fi
  done
fi
if [ "$old_claude" = 1 ]; then
  echo "Migrating old Claude agent config to shared ai adapters"
fi

install_dir ai "$HOME/.ai"

mkdir -p "$HOME/.claude/commands"
mkdir -p "$HOME/.codex/skills"
mkdir -p "$HOME/.gemini/commands"
cp -v claude/CLAUDE.md "$HOME/.claude/CLAUDE.md"
cp -v codex/AGENTS.md "$HOME/.codex/AGENTS.md"
# rm -f first so a stale symlink at the dst is not followed by cp.
rm -f "$HOME/.gemini/GEMINI.md"
cp -v gemini/GEMINI.md "$HOME/.gemini/GEMINI.md"
for f in vimrc bash_profile gitconfig; do cp -v "$f" "$HOME/.$f"; done
for f in claude/commands/*.md; do cp -v "$f" "$HOME/.claude/commands/$(basename "$f")"; done
for f in gemini/commands/*.toml; do cp -v "$f" "$HOME/.gemini/commands/$(basename "$f")"; done
for d in codex/skills/*; do
  target="$HOME/.codex/skills/$(basename "$d")"
  install_dir "$d" "$target"
done
case "$SHELL" in */bash) ;; *) echo "Warning: your shell is $SHELL, not bash. Run: chsh -s \$(which bash)" ;; esac
case "$(uname -s)" in Darwin) echo "Reminder: brew install coreutils bash bash-completion@2" ;; esac
