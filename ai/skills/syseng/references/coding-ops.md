# Coding And Operations Rules

## Language Defaults

1. C: POSIX APIs, syscalls, memory management, daemons, and system-library
   interop.
2. Rust: systems tooling, CLIs, network services, and correctness-focused code.
3. Shell: automation and glue only.
4. Python: tooling, diagnostics, quick prototypes, data processing.

## Verbose Instrumentation

- Every new diagnostic CLI or systems tool should support `-v` or `--verbose`.
- Verbose output goes to stderr, never stdout.
- Use consistent prefixes so logs are greppable.
- Log key state transitions, syscall results, branch decisions, network I/O,
  and file operations where useful.

## C

- Check every return value.
- Handle `errno` explicitly.
- Use goto-based cleanup when it keeps error paths correct.
- Free allocations on every exit path.
- Use transactional file I/O for durable writes.
- Headers get include guards and minimal public APIs.

## Rust

- Propagate errors with `?`.
- Avoid `.unwrap()` in library code.
- Use `tempfile::NamedTempFile` plus `persist()` for atomic writes.
- Prefer `std` over crates when equivalent.
- Use `clap` or project-local parsing for `-v`/`--verbose`.

## Shell

- Start scripts with `set -euo pipefail` for bash.
- Trap `EXIT` for cleanup.
- Quote variables.
- Keep shellcheck-clean.
- Use functions for reusable logic and keep main flow at the bottom.

## Python

- Use `argparse` for CLIs.
- Use `logging`, not `print`, for diagnostics.
- Use context managers for files, sockets, subprocesses, and temp resources.
- Type-hint function signatures.
- Map `-v`/`--verbose` to `logging.DEBUG`.

## Operational Rules

- Diagnose before fixing.
- Prefer logs, status, cgroups, namespaces, route tables, packet counters,
  strace, perf, or targeted probes over guessing.
- Write small diagnostic scripts when repeated manual checks would be brittle.
- Keep fixes minimal and targeted.
- Explain root cause and why the fix is correct.

## Documentation Rules

- Source headers are useful for standalone tools and scripts.
- systemd units should include comments for purpose, dependencies, and ordering
  constraints when non-obvious.
- Update docs when new dependencies, operational constraints, or workarounds
  affect other users.
- Comments explain why.

