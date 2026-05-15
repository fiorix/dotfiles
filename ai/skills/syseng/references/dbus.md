# D-Bus

## Architecture

- Message-based IPC with method calls, replies, errors, signals, and
  properties.
- System bus: machine-wide services, usually `/run/dbus/system_bus_socket`.
- Session bus: per-user desktop/user services.
- Bus names: unique names like `:1.42`; well-known names like
  `org.freedesktop.NetworkManager`.
- Object paths: hierarchical instance paths.
- Interfaces: method, signal, and property namespaces on objects.

## Message Types

- Method call: client to service, expects reply.
- Method return: successful reply.
- Error: failed reply with error name and message.
- Signal: broadcast event, subscribed by match rules.

## Type System

- Basic: `y`, `b`, `n`, `q`, `i`, `u`, `x`, `t`, `d`, `s`, `o`, `g`, `h`.
- Containers: arrays `aT`, structs `(...)`, dicts `a{KT}`, variants `v`.
- `a{sv}` is the common property bag pattern.

## Tools

- `busctl list`
- `busctl tree NAME`
- `busctl introspect NAME PATH`
- `busctl call NAME PATH IFACE METHOD SIGNATURE ARGS`
- `busctl get-property NAME PATH IFACE PROP`
- `busctl monitor NAME`
- `busctl capture`
- `gdbus introspect`, `gdbus call`, `gdbus monitor`
- `dbus-send` when available, though `busctl` is usually cleaner.

## Common System Bus Services

- `org.freedesktop.systemd1`: units, jobs, transient units.
- `org.freedesktop.login1`: sessions, users, seats, power operations.
- `org.freedesktop.hostname1`: hostnames and chassis metadata.
- `org.freedesktop.timedate1`: time zone and NTP state.
- `org.freedesktop.locale1`: locale and keyboard.
- `org.freedesktop.resolve1`: DNS resolution and link DNS state.
- `org.freedesktop.network1`: networkd links.
- `org.freedesktop.machine1`: containers and VMs.
- `org.freedesktop.NetworkManager`: network management when installed.
- `org.freedesktop.UDisks2`: block devices and mounts.
- `org.freedesktop.PolicyKit1`: authorization checks.

## Activation

- Activation files live in `/usr/share/dbus-1/system-services` or
  `/usr/share/dbus-1/services`.
- Prefer `SystemdService=` in activation files when systemd owns the service.
- A `Type=dbus` systemd service with `BusName=` is considered ready when the
  well-known bus name appears.

## Security

- `dbus-broker` and `dbus-daemon` enforce bus policy.
- Policy files live in `/etc/dbus-1/system.d` and
  `/usr/share/dbus-1/system.d`.
- Polkit is commonly used for high-level authorization of privileged methods.

## Programming

- C, sd-bus: `sd_bus_open_system()`, `sd_bus_call_method()`,
  `sd_bus_get_property_string()`, `sd_bus_add_match()`,
  `sd_bus_request_name()`.
- C, GDBus: `g_bus_get_sync()`, `g_dbus_proxy_new_for_bus_sync()`,
  `g_dbus_proxy_call_sync()`.
- Rust: `zbus`, async-native, proxy macro support.
- Go: `github.com/godbus/dbus`.
- Python: `dasbus`, `pydbus`, `jeepney`; avoid older `dbus-python` unless the
  project already depends on it.

