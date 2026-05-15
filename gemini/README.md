# Gemini CLI Configuration

This directory contains Gemini-specific configurations and resources, mirroring the
structure of `claude/` and `codex/`.

## Structure

- `README.md`: This file.
- `GEMINI.md`: Root-level adapter (located in the repository root) for instructions.

## Shared Skills

Gemini CLI should load domain-specific context from `../ai/skills/` when relevant.
Refer to the root `GEMINI.md` for details on how to activate these contexts.
