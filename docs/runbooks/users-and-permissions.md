# Users, groups, and permissions

## Read-only review

```bash
id
getent passwd
getent group sudo
stat -c '%A %U:%G %n' /path/to/file
namei -l /path/to/file
```

`getent` uses the system's configured identity sources. Avoid publishing account listings or file paths from a real host.

## Lab-only account management

On a disposable VM, an administrator may create a lab account with `sudo adduser labuser` and remove it after practice with `sudo deluser labuser`. Confirm the exact account name before any account change. Never remove a system account based only on an unfamiliar name.

Use the least privilege needed. Avoid `chmod -R 777`; it grants broad access and usually hides the underlying ownership or group problem. Prefer a specific owner, group, and permission set.
