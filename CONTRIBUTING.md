# Contributing to Wonkru MDM

Thanks for your interest in improving Wonkru MDM. This document explains how to set up
the project, the conventions we follow, and how to submit changes.

## Ways to contribute

- Report bugs and request features through GitHub issues.
- Fix bugs or implement features and open a pull request.
- Report security issues privately — see [SECURITY.md](SECURITY.md).

## Development setup

Follow [README.md](README.md#quick-start-development) to start the server and run the agent
on an emulator. Create `wonkru_mdm_server/config/passwords.yaml` with the required secrets
before starting the server.

Prerequisites: Dart `^3.12.2`, Flutter `^3.44.4`, and Serverpod CLI `4.1.2`.

## Repository layout

| Package | Responsibility |
|---|---|
| `wonkru_core_server` / `wonkru_core_client` | Shared enums, DTOs, and catalogs (Serverpod module) |
| `wonkru_mdm_server` | Serverpod backend and admin/device endpoints |
| `wonkru_mdm_flutter` | Flutter web admin panel |
| `wonkru_mdm_mobil` | Android Device Owner agent (Flutter + Kotlin) |
| `deploy/vps` | Single-VPS deployment |

## Conventions

### General

- Never edit generated code: `wonkru_mdm_server/lib/src/generated/`,
  `wonkru_mdm_client/`, and `wonkru_core_client/`. Change `.spy.yaml` models, endpoints,
  or `lib/server.dart` instead, then regenerate with `serverpod generate`.
- Endpoints stay thin; business logic lives under `lib/src/service/`.
- Shared enums, device DTOs, and catalogs belong in `wonkru_core_server` so the server,
  panel, and agent use one definition.

### Formatting and analysis

```bash
dart analyze
dart format .
```

Run both before opening a pull request. The `Analyze` and `Format` workflows enforce
them.

### Tests

Tests need no Docker: the test configuration uses an embedded PostgreSQL.

```bash
cd wonkru_mdm_server && dart test      # backend
cd wonkru_mdm_flutter && flutter test  # panel
cd wonkru_mdm_mobil && flutter test    # agent
```

Add or update tests for logic changes. UI changes are verified by hand in the running
panel; testing effort goes into the logic layer (controllers, request mapping, codecs,
endpoint behavior).

### Commits and pull requests

- Use [Conventional Commits](https://www.conventionalcommits.org/), for example
  `fix(panel): ...`, `refactor(server): ...`, `docs: ...`.
- Keep pull requests focused on one change.
- Describe what changed and how you verified it. Link the related issue.
- Make sure the CI checks pass.

## Reporting bugs

Open an issue with the bug report template. Include the affected package, steps to
reproduce, expected vs. actual behavior, and relevant logs. Do not include secrets.
