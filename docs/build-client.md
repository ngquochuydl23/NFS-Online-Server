# Building the Client Plugins

This document explains how to build the three Windows x86 ASI client plugins
from source:

- `net_u2.asi` — Need for Speed: Underground 2
- `net_mw.asi` — Need for Speed: Most Wanted (2005)
- `net_carbon.asi` — Need for Speed: Carbon

## 1. Requirements

- Linux x86-64 or Termux
- Python 3
- `file` (the `file` command, usually installed by default)
- Zig 0.16.0 (auto-downloaded by the build script if not already installed)

## 2. Build

```bash
cd source/client-zig
./build_linux.sh
```

The script does the following automatically:

1. Locates Zig 0.16.0, or downloads it into `.tools/` via `bootstrap_zig.sh`.
2. Validates the Zig source (`tools/check_source.py`).
3. Validates the configured ports against `config/server.toml`
   (`tools/check_ports.py`).
4. Formats the Zig source (`zig fmt`).
5. Builds all three plugins (`zig build -Doptimize=ReleaseSmall`).
6. Audits the PE output (`tools/audit_pe.py`).
7. Copies the matching `.ini` files next to the binaries.

## 3. Output

The plugins and their configuration files are written to:

```text
source/client-zig/zig-out/bin/
├── net_u2.asi
├── net_u2.ini
├── net_mw.asi
├── net_mw.ini
├── net_carbon.asi
└── net_carbon.ini
```

## 4. Install

Copy the matching `.asi` and `.ini` pair into each game's ASI/plugin directory:

| Game | Files |
|---|---|
| Underground 2 | `net_u2.asi` + `net_u2.ini` |
| Most Wanted (2005) | `net_mw.asi` + `net_mw.ini` |
| Carbon | `net_carbon.asi` + `net_carbon.ini` |

> Do not combine these plugins with older hooks that patch the same networking
> or Carbon Online code. All Underground 2 participants in a shared-port room
> must use the current client version.

## 5. Point the clients at your server

Edit the `.ini` beside each plugin (or `config/server.toml` for the server side)
so the client connects to your server address instead of the default. See the
`PUBLIC_HOST` / server address fields in the respective `.ini` files.
