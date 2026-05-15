# systemd

For code review of systemd itself or systemd-style C, also load
`systemd-review.md`. It contains the review baseline derived from
`masoncl/review-prompts/systemd`.

## Unit Types

- `service`: daemons and oneshot tasks. Key types: `simple`, `exec`,
  `forking`, `oneshot`, `notify`, `dbus`.
- `timer`: calendar or monotonic scheduling. Use `Persistent=true` for missed
  run catch-up and `RandomizedDelaySec=` for load spreading.
- `socket`: socket activation. Use `ListenStream=`, `ListenDatagram=`,
  `Accept=no|yes`, `FileDescriptorName=`.
- `mount` and `automount`: declarative mounts and on-demand mounts.
- `path`: inotify-backed activation with `PathExists=`, `PathChanged=`,
  `PathModified=`, `DirectoryNotEmpty=`.
- `target`: grouping and synchronization only.
- `slice`: cgroup hierarchy node for resource management.
- `scope`: externally created process group, commonly via `systemd-run`.

## Dependencies And Ordering

- Dependencies: `Requires=`, `Wants=`, `BindsTo=`, `Requisite=`,
  `Conflicts=`, `PartOf=`.
- Ordering: `Before=`, `After=`.
- Dependency and ordering are independent. Specify both when both are required.
- Conditions skip units; asserts fail units. Examples: `ConditionPathExists=`,
  `ConditionVirtualization=`, `AssertPathExists=`.
- Install section creates enable-time symlinks with `WantedBy=` or
  `RequiredBy=`.

## Resource Control

- CPU: `CPUQuota=`, `CPUWeight=`, `AllowedCPUs=`.
- Memory: `MemoryMax=`, `MemoryHigh=`, `MemoryLow=`, `MemoryMin=`,
  `MemorySwapMax=`.
- I/O: `IOWeight=`, `IODeviceWeight=`, `IOReadBandwidthMax=`,
  `IOWriteBandwidthMax=`, `IOReadIOPSMax=`, `IOWriteIOPSMax=`.
- PIDs: `TasksMax=`.
- Containers need `Delegate=yes` when they manage cgroup subtrees.

## Sandboxing

- Namespaces: `PrivateNetwork=`, `PrivateTmp=`, `PrivateDevices=`,
  `PrivateUsers=`, `PrivateMounts=`, `PrivateIPC=`.
- Filesystem: `ProtectSystem=strict`, `ProtectHome=`, `ReadWritePaths=`,
  `ReadOnlyPaths=`, `InaccessiblePaths=`, `TemporaryFileSystem=`,
  `BindPaths=`, `BindReadOnlyPaths=`.
- Root images: `RootDirectory=`, `RootImage=`, `RootHash=`, `MountAPIVFS=`.
- Capabilities: `CapabilityBoundingSet=`, `AmbientCapabilities=`.
- Syscalls: `SystemCallFilter=`, `SystemCallArchitectures=`,
  `SystemCallErrorNumber=`.
- Hardening: `NoNewPrivileges=`, `ProtectKernelTunables=`,
  `ProtectKernelModules=`, `ProtectKernelLogs=`, `ProtectControlGroups=`,
  `ProtectClock=`, `RestrictRealtime=`, `RestrictSUIDSGID=`,
  `RestrictNamespaces=`, `LockPersonality=`, `MemoryDenyWriteExecute=`.
- Use `systemd-analyze security <unit>` for a coarse hardening score.

## Lifecycle

- Hooks: `ExecStartPre=`, `ExecStart=`, `ExecStartPost=`, `ExecReload=`,
  `ExecStop=`, `ExecStopPost=`.
- Prefixes: `-` ignores failure, `+` runs with full privileges, `!` elevates
  credentials without full root behavior.
- Restart: `Restart=on-failure|always|on-abnormal|on-abort|on-watchdog`,
  `RestartSec=`, `RestartSteps=`, `RestartMaxDelaySec=`.
- Timeouts: `TimeoutStartSec=`, `TimeoutStopSec=`, `TimeoutAbortSec=`.
- Watchdog: `WatchdogSec=` plus `sd_notify("WATCHDOG=1")`.
- Kill behavior: `KillMode=control-group|mixed|process`, `KillSignal=`,
  `FinalKillSignal=`.
- Credentials: `LoadCredential=`, `SetCredential=`, read from
  `$CREDENTIALS_DIRECTORY`.

## journald

- Persistent storage requires `/var/log/journal` or `Storage=persistent`.
- Useful config: `SystemMaxUse=`, `SystemKeepFree=`, `MaxFileSec=`,
  `Compress=`, `RateLimitIntervalSec=`, `RateLimitBurst=`.
- Query with `journalctl -u UNIT`, `-b`, `--since`, `--until`, `-p err`,
  `-f`, `-o json`, `_SYSTEMD_UNIT=`, `_PID=`, `SYSLOG_IDENTIFIER=`.
- For structured C logging, use `sd_journal_send()`.

## resolved, networkd, tmpfiles

- `systemd-resolved`: inspect with `resolvectl status`, query with
  `resolvectl query`, flush with `resolvectl flush-caches`.
- `systemd-networkd`: config in `/etc/systemd/network/*.network`, `.netdev`,
  `.link`; inspect with `networkctl status` and `networkctl list`.
- `systemd-tmpfiles`: config in `/etc/tmpfiles.d` and
  `/usr/lib/tmpfiles.d`; run `systemd-tmpfiles --create --remove --clean`.

## Debugging Tools

- `systemctl daemon-reload`: reload unit files, does not restart services.
- `systemctl edit UNIT`: create override.
- `systemctl list-dependencies UNIT --reverse`: reverse dependency graph.
- `systemd-analyze blame`, `critical-chain`, `verify`, `plot`.
- `systemd-run --scope -p MemoryMax=1G ./cmd`: transient scope.
- `busctl tree`, `busctl introspect`, `busctl call`, `busctl monitor`.
- `loginctl list-sessions`, `loginctl show-session`, `loginctl enable-linger`.

## PID1 Review Hotspots

- No threads in PID1.
- No NSS lookups from PID1.
- No synchronous IPC from PID1 to services it manages.
- Unit, job, D-Bus object, event source, and async callback lifetimes must be
  explicit.
- New unit settings need parser, D-Bus, systemctl/bus utility, docs, tests, and
  fuzz coverage where applicable.
- daemon-reload must fail without corrupting active state.
