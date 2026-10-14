# Linux Admin Lab

A practical Linux system administration lab for learning routine host operations on an Ubuntu Server virtual machine. It combines a read-only host audit tool, a cautious archive backup helper, command-line examples, and incident-response runbooks.

## What is included

- `scripts/sysadmin-audit.sh` — read-only snapshot of OS/kernel, CPU, memory, filesystems, failed systemd units, network configuration, listening sockets, and top processes.
- `scripts/backup-create.sh` — creates and verifies a timestamped `.tar.gz` archive without deleting or changing the source.
- Runbooks for services, storage, networking, users and permissions, backups, and basic security.
- Hands-on labs that explain the goal, commands, expected observations, and cleanup for common admin tasks.

## Supported environment

Designed for Ubuntu Server 22.04/24.04 and similar systemd-based Linux distributions. The audit script is read-only and does not require root. The backup helper needs Bash, `tar`, and standard core utilities; it writes only to the destination directory you provide. Some report sections are omitted when optional commands such as `systemctl`, `ip`, or `ss` are unavailable.

Use a disposable virtual machine for hands-on labs. Review each command before running it. Some examples require `sudo` and change system configuration.

## Quick start

```bash
git clone https://github.com/mohitchoudhary666/linux-admin-lab.git
cd linux-admin-lab
chmod +x scripts/*.sh
./scripts/sysadmin-audit.sh
```

Save a diagnostic report to a private local file:

```bash
./scripts/sysadmin-audit.sh --output "$HOME/linux-audit.txt"
```

The report may reveal hostnames, addresses, usernames, service names, and process details. Review and redact it before sharing.

Create a backup archive (source is never removed):

```bash
mkdir -p "$HOME/backups"
./scripts/backup-create.sh "$HOME/Documents" "$HOME/backups"
```

## Learning path

1. [First response and host inventory](docs/runbooks/first-response.md)
2. [Users, groups, and permissions](docs/runbooks/users-and-permissions.md)
3. [Services and systemd](docs/runbooks/services-and-systemd.md)
4. [Storage and filesystems](docs/runbooks/storage-and-filesystems.md)
5. [Networking](docs/runbooks/networking.md)
6. [Logs and troubleshooting](docs/runbooks/logs-and-troubleshooting.md)
7. [Backups and restore practice](docs/runbooks/backups.md)
8. [Security fundamentals](docs/runbooks/security-basics.md)
9. [Hands-on labs](labs/README.md)

## Safety notes

- `sysadmin-audit.sh` only reads host state. It does not restart services, install packages, scan remote hosts, or modify firewall rules.
- `backup-create.sh` creates a new archive and verifies its table of contents. It never deletes the source or existing archives.
- Runbooks distinguish inspection commands from commands that change the system. Check paths and targets before using commands with `sudo`.
- Do not paste passwords, private keys, tokens, or unredacted system reports into issues.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for shell style, safety expectations, and documentation guidance. Suggestions and fixes are welcome.

## License

MIT. See [LICENSE](LICENSE).
