#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p "$HOME/.claude/commands"
cp -v claude/CLAUDE.md "$HOME/.claude/CLAUDE.md"
for f in vimrc bashrc gitconfig; do cp -v "$f" "$HOME/.$f"; done
for f in claude/commands/*.md; do cp -v "$f" "$HOME/.claude/commands/$(basename "$f")"; done
case "$SHELL" in */bash) ;; *) echo "Warning: your shell is $SHELL, not bash. Run: chsh -s \$(which bash)" ;; esac
case "$(uname -s)" in Darwin) echo "Reminder: brew install coreutils bash bash-completion@2" ;; esac
