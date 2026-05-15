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

## Process Execution Boundaries

- Treat paths that lead to `exec*`, `Command`, daemon activation, helper CLIs,
  interpreters, hooks, plugins, or privileged file opens as hostile until
  proven otherwise.
- Resolve the candidate once to an absolute canonical path, validate that exact
  resolved object, and execute/open that same resolved path. Do not validate one
  spelling and execute another.
- Validate executable targets as regular files with execute permission. Reject
  directories, FIFOs, sockets, device nodes, missing files, and ambiguous
  symlink chains.
- Avoid recursive discovery under user-controlled or broad roots. Do not walk
  FUSE, network, automount, pseudo, or other surprising filesystems unless the
  task explicitly requires it and has loop, depth, mount, and timeout limits.
- For PATH lookup, build a bounded search list. Prefer user-supplied paths first
  when they are part of the contract, then conventional system directories.
  Validate the found executable before use.
- Preserve child process PATH semantics for wrapper tools. If a validated CLI
  may depend on `/usr/bin/env`, language runtimes, shell helpers, or package
  manager shims, pass a PATH containing the validated search list rather than
  only the executable's directory.
- Check containing directories where trust matters. Reject group- or
  world-writable executable files and unsafe writable ancestors unless sticky
  directory semantics or the local threat model explicitly justify them.
- Document residual race assumptions. Canonicalize plus metadata checks remove
  common PATH, symlink, and replacement tricks, but they are not a complete
  defense against same-user races without descriptor-based execution or stronger
  platform support.

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
