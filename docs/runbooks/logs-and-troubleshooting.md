# Logs and troubleshooting

## Inspect recent system logs

```bash
journalctl -p warning --since "2 hours ago" --no-pager
journalctl -u example.service --since today --no-pager
tail -n 100 /var/log/syslog
```

Ubuntu commonly uses journald and may also provide `/var/log/syslog`; other distributions differ. Use the log source configured by the host. Filter by time and service before reading large logs.

## Make a useful incident note

Record the host and environment (without sharing secrets), timestamp and timezone, exact symptom, relevant log lines, commands run, observed output, changes made, and the verification result. Redact tokens, email addresses, public IPs if sensitive, usernames, and customer data before sharing logs.
