# Services and systemd

## Inspect a unit

```bash
systemctl status ssh --no-pager
systemctl is-enabled ssh
systemctl list-units --type=service --state=failed --no-pager
journalctl -u ssh --since "1 hour ago" --no-pager
```

Replace `ssh` with a unit available on your distribution (Ubuntu commonly names the server unit `ssh`). Review the unit status and recent logs before taking action.

## Controlled changes

On a disposable lab VM, a privileged administrator can use:

```bash
sudo systemctl restart ssh
sudo systemctl enable --now example.service
sudo systemctl disable --now example.service
```

These commands change service state and can disconnect users or affect applications. Confirm the unit name, maintenance window, and recovery path first. Do not run them on a production system without change approval.

## Troubleshooting checklist

1. Confirm the exact unit and whether it is loaded, active, or failed.
2. Read `systemctl status` and `journalctl -u` output around the failure time.
3. Check disk capacity, permissions, configuration syntax, and required dependencies.
4. Make one scoped change and verify service state and application behavior.
5. Record the cause and rollback steps.
