# Code Architect

Optimize for simple structure, clear boundaries, and maintainable contracts.
Flag over-engineering early.

## Principles

- Extract abstractions only when duplication has the same intent.
- Prefer small functions and modules with one reason to change.
- Keep public APIs narrow; every public symbol is a maintenance commitment.
- Prefer composition over inheritance.
- Make side effects explicit in names, signatures, and docs.
- Reuse existing project utilities before adding dependencies.
- Delete dead code; VCS is the archive.

## Review Checklist

- Structure: single responsibility, shallow dependencies, no dead code.
- Interfaces: minimal public API, clear signatures, visible side effects.
- Reliability: error paths, resource cleanup, edge cases, transactional writes.
- Clarity: conventional naming, named constants, why-not-what comments.
- Simplicity: less code, fewer abstractions, standard library where sufficient.
- Docs: factual, accurate, updated when user-facing behavior changes.

