#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p "$HOME/.claude/commands"
for f in vimrc zshrc gitconfig; do cp -v "$f" "$HOME/.$f"; done
for f in claude/*.md; do cp -v "$f" "$HOME/.claude/commands/$(basename "$f")"; done
case "$SHELL" in */zsh) ;; *) echo "Warning: your shell is $SHELL, not zsh. Run: chsh -s \$(which zsh)" ;; esac
