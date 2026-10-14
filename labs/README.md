# Hands-on Linux administration labs

Run these exercises in an Ubuntu Server virtual machine you own or are authorized to administer. Take a VM snapshot first. The inspection labs are read-only; the account and service labs include changes and must be done only in a disposable environment.

## Lab 1 — Host inventory

**Goal:** Identify OS release, kernel, memory, disk capacity, routes, listening sockets, and failed units.

```bash
./scripts/sysadmin-audit.sh
```

**Observe:** Which filesystem has the least free space? Are any units failed? Which interfaces and local sockets are active? Redact sensitive values before sharing the report.

## Lab 2 — Backup and archive inspection

**Goal:** Create a backup of sample data and inspect its contents.

```bash
mkdir -p "$HOME/lab-data" "$HOME/lab-backups"
printf 'practice file\n' > "$HOME/lab-data/example.txt"
./scripts/backup-create.sh "$HOME/lab-data" "$HOME/lab-backups"
tar -tzf "$HOME/lab-backups"/*.tar.gz
```

**Observe:** The source file remains in place and the archive contains the relative `lab-data/` path.

## Lab 3 — systemd investigation

**Goal:** Inspect one known service without changing it.

```bash
systemctl status cron --no-pager
journalctl -u cron --since "1 hour ago" --no-pager
```

If the service name differs on your distribution, use `systemctl list-units --type=service` to find an installed unit. Do not restart a service unless you intentionally want to practice that state change in the disposable VM.

## Lab 4 — Permissions

**Goal:** Understand owner, group, and mode bits.

```bash
touch "$HOME/permission-lab.txt"
stat -c '%A %U:%G %n' "$HOME/permission-lab.txt"
chmod 640 "$HOME/permission-lab.txt"
stat -c '%A %U:%G %n' "$HOME/permission-lab.txt"
```

**Cleanup:** `rm "$HOME/permission-lab.txt"` removes only the practice file created by this lab.
