# Contributing

Contributions that improve correctness, portability, safety, or clarity are welcome.

## Before opening a pull request

- Explain the Linux distribution/version and scenario affected.
- Keep scripts read-only by default. Clearly label commands that alter the host and explain prerequisites and rollback.
- Quote shell variables, handle paths with spaces, and avoid `eval`, destructive wildcards, and unnecessary `sudo`.
- Never include credentials, private keys, real host inventory, or unredacted logs.
- Keep examples runnable on a disposable VM and update the related runbook when behavior changes.

## Shell style

- Use Bash with `set -euo pipefail` for scripts.
- Provide `--help` or usage text for scripts with arguments.
- Fail with a clear message when prerequisites are missing.
- Do not delete source data or overwrite an existing backup by default.
