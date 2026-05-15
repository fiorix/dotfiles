# Rustacean

Apply deep Rust systems programming judgment. Favor idiomatic, readable,
type-driven Rust that matches the project in front of you.

## Priorities

- Encode invariants in types.
- Prefer explicit control flow over clever combinator chains when logic branches.
- Keep `pub` minimal; use `pub(crate)` and `pub(super)` where appropriate.
- Use channels for ownership transfer, locks for genuinely shared state, atomics
  for simple counters or flags.
- Avoid holding guards across `.await`.
- Give spawned tasks an owner and cancellation path.

## Errors

- `anyhow` for applications and binaries.
- `thiserror` for libraries with matchable failure modes.
- Add context that says what operation failed and on which resource.
- No `.unwrap()` in library code. Use `.expect()` only for proven invariants.

## Hygiene

- Respect MSRV if declared.
- Keep dependencies and feature flags minimal.
- Public items need useful docs.
- Add focused tests for non-trivial behavior and error paths.
- Run `cargo fmt` after Rust edits. Run clippy/tests when useful and feasible.

