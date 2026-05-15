# Varlink

## Overview

- JSON-based IPC over direct sockets. No broker.
- One JSON object per message, delimited by NUL.
- Supports request/reply and streaming replies with continuation markers.
- No signal model; use streaming calls or file descriptor passing where
  appropriate.

## Protocol

- Method call:

```json
{"method":"org.example.Interface.Method","parameters":{"key":"value"}}
```

- Reply:

```json
{"parameters":{"result":"value"}}
```

- Error:

```json
{"error":"org.example.Interface.ErrorName","parameters":{"reason":"details"}}
```

- Streaming calls use `"more": true`; streaming replies use `"continues": true`
  until the final reply.
- Every service implements `org.varlink.service.GetInfo`.

## IDL

- Interfaces are defined in `.varlink` files.
- Types: `bool`, `int`, `float`, `string`, `object`, nullable `?type`, arrays
  `[]type`, maps `[string]type`, structs `(field: type, ...)`.

Example:

```text
interface org.example.Counter
type State (count: int, active: bool)
method GetState() -> (state: State)
method Increment(amount: int) -> (new_count: int)
method Subscribe() -> (state: State)
error NotReady()
```

## systemd Interfaces

- `io.systemd.Resolve`: DNS resolution.
- `io.systemd.UserDatabase`: user and group records.
- `io.systemd.MachineImage`, `io.systemd.Machine`: machine/container state.
- `io.systemd.NameServiceSwitch`: NSS integration.
- `io.systemd.Credentials`: service credentials.
- `io.systemd.Journal`: journal access.
- `io.systemd.Network`: networkd management.
- Socket paths commonly follow `/run/systemd/<component>/io.systemd.<Name>`.

## Tools

- `varlinkctl info SOCKET`
- `varlinkctl list-interfaces SOCKET`
- `varlinkctl introspect SOCKET INTERFACE`
- `varlinkctl call SOCKET METHOD JSON`
- `varlinkctl monitor SOCKET METHOD`

Example:

```sh
varlinkctl call /run/systemd/resolve/io.systemd.Resolve \
  io.systemd.Resolve.ResolveHostname '{"name":"example.com"}'
```

## Varlink vs D-Bus

- Varlink: direct socket, JSON, simple type system, good for system daemons,
  container tooling, point-to-point IPC, and high-throughput streaming.
- D-Bus: broker, binary protocol, rich types, service activation, broadcast
  signals, object hierarchy, polkit integration.
- Newer systemd functionality may be Varlink-first.

## Programming

- C, sd-varlink: `sd_varlink_connect()`, `sd_varlink_call()`,
  `sd_varlink_observe()`, `sd_varlink_server_new()`,
  `sd_varlink_server_bind_method()`.
- Go: `github.com/varlink/go`.
- Python: `varlink`.
- Rust: `varlink-rs`.
- Raw protocol is simple with Unix sockets plus JSON plus NUL framing.

## Socket Activation

- Use a `.socket` with `ListenStream=/run/myservice/io.example.Interface`.
- Matching `.service` receives fds via `sd_listen_fds(3)`.
- Attach with `sd_varlink_server_listen_fd()`.

