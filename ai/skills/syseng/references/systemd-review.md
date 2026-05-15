# systemd Review Baseline

Derived from the `systemd/` prompts in
`https://github.com/masoncl/review-prompts` (MIT licensed). Use this as a
review checklist for systemd-style C, PID1, sd-bus, cleanup attributes, mount
namespaces, and crash/debug analysis.

## Review Protocol

1. Identify every modified function and its file.
2. Load subsystem context by path:
   - PID1, unit lifecycle, jobs, transactions, service execution:
     `src/core/`, `core.md` style checks.
   - sd-bus and D-Bus interfaces: `src/libsystemd/sd-bus/`,
     `src/shared/bus-*.c`, `src/core/dbus-*.c`.
   - namespaces and mounts: `namespace.c`, `namespace-util.c`,
     `nspawn-mount.c`, `unshare`, `setns`, `clone`, `CLONE_NEW*`.
   - cleanup and ownership: `_cleanup_`, `TAKE_PTR`, `TAKE_FD`,
     custom cleanup functions.
3. For each function, trace concrete call paths before reporting anything.
4. Check error handling, resource ownership, FD safety, PID1 restrictions,
   style, caller contracts, and new error propagation.
5. Run a false-positive pass before reporting. Do not report bugs that are
   impossible on the traced path.

## Severity

- Critical: security issue, crash, data corruption, PID1 deadlock, use-after
  free, double-free, severe long-running FD leak.
- High: functional bug, memory/resource leak, incorrect error handling.
- Medium: style or robustness issue with realistic impact.
- Low: naming, organization, minor maintainability suggestion.

## Core systemd C Rules

- systemd returns negative errno values, for example `-EINVAL`.
- Convert libc `-1`/`errno` style with `RET_NERRNO()` or equivalent local
  pattern.
- Constructors may return `NULL` on OOM; lookup helpers may return `NULL` for
  not found.
- Program code logs user-visible errors; library/shared code generally should
  not log except at debug level.
- Use combined log-and-return helpers in program code where appropriate.
- Use synthetic errno wrappers when the error did not come from a failing call.
- `assert_return()` is for public API contract validation. `assert()` is for
  internal programming errors. Neither is runtime error handling.
- Cast intentionally ignored results to `(void)`.

## Memory And Ownership

- Check every allocation.
- Prefer cleanup attributes for local resource ownership.
- Initialize cleanup variables to safe invalid values: pointers to `NULL`, FDs
  to `-EBADF`.
- Cleanup runs in reverse definition order. Define guards/locks before the
  resources that must be cleaned while guarded.
- Do not mix local goto-cleanup style and cleanup attributes in the same
  function unless the existing file has a clear reason.
- Use `TAKE_PTR()` and `TAKE_FD()` when returning ownership, inserting into an
  owning container, or transferring to a longer-lived object.
- Do not use a variable after `TAKE_PTR()` or `TAKE_FD()`.
- Destructors should be NULL-safe, tolerate partial initialization, and return
  NULL when that is the local convention.

## File Descriptors

- Every created FD needs close-on-exec at creation time:
  `O_CLOEXEC`, `SOCK_CLOEXEC`, `MSG_CMSG_CLOEXEC`, `F_DUPFD_CLOEXEC`, or
  `fopen()` mode `e`.
- Avoid `dup()`; duplicate with `fcntl(fd, F_DUPFD_CLOEXEC, 3)`.
- Use `O_NONBLOCK` for foreign regular files where blocking behavior is not
  controlled by systemd.
- Transfer returned FDs with `TAKE_FD()`.

## PID1 Invariants

- PID1 must not use worker threads. Use helper processes instead.
- PID1 must not perform NSS lookups. User/group/host resolution can call back
  into services PID1 is responsible for starting.
- PID1 must not synchronously wait for services it manages. Use async IPC and
  explicit timeouts.
- PID1 must survive OOM, missing files, invalid config, failed reloads, and
  partially initialized state.
- New unit settings normally need consistent support in unit-file parsing,
  D-Bus properties, systemctl/bus utility code, docs, tests, and fuzz corpus.
- daemon-reload must not corrupt existing runtime state on failure.

## Unit, Job, And Event Lifetimes

- Unit state transitions must be legal and cleanup must happen in the right
  states.
- `unit_ref()` and `unit_unref()` must balance, including async paths.
- Jobs must be linked/unlinked from units correctly and complete callbacks
  must run exactly once.
- Event sources must be disabled/unrefd before associated userdata is freed.
- Hashmaps/sets must not be mutated during ordinary iteration unless using the
  safe remove-while-iterating helper.

## Namespace And Mount Review

- Mount namespace setup should first create the namespace, then stop parent
  propagation, then apply mounts, then set final propagation policy.
- Namespace FDs require `O_CLOEXEC` and cleanup ownership.
- `setns()` must validate FD state and namespace type.
- User namespace and mount namespace ordering matters; avoid privilege or
  mount-propagation leaks.
- For executor setup, review ordering of network, IPC, cgroup, PID, mount, and
  UTS namespaces. `/proc` visibility depends on PID namespace ordering.
- `pivot_root` requires the new root to be a mount point and the old root to be
  unmounted safely after the pivot.
- Check all `unshare()`, `mount()`, `setns()`, and `clone()` error paths.

## Debugging Protocol

- Extract signal, fault address, assertion text, stack frames, registers when
  available, and relevant locals.
- Classify crash type:
  - SIGSEGV: NULL dereference, use-after-free, invalid pointer math, stack
    overflow.
  - SIGABRT: assertion, allocator corruption, double-free.
  - SIGFPE: divide by zero or trapped integer overflow.
- Trace backwards from the failing frame to entry point and required state.
- For PID1 crashes, add extra scrutiny: a crash can freeze or reboot the host.
- For cleanup issues, verify LIFO order, compatibility of cleanup function with
  every possible variable value, and explicit ownership transfer.

## False Positive Elimination

- Prove the exact code path can execute.
- Check whether prerequisites were validated at an API boundary.
- Do not demand defensive checks for impossible states in internal helpers.
- Best-effort cleanup failures may be intentionally ignored with `(void)`.
- Test/debug code can have different standards from production PID1 code.
- Feature-gated code only matters when the feature can actually be enabled.
- For every report, include path, triggering condition, and evidence.

