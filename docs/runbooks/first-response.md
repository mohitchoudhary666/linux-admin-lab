# First response and host inventory

Use this sequence when you receive a Linux host alert. Record timestamps and commands; avoid changing state until you understand the symptom and scope.

## 1. Confirm scope

- Which service, host, environment, and users are affected?
- When did the issue start? Is it ongoing or intermittent?
- Did a deploy, configuration change, traffic spike, or maintenance event occur?
- Preserve the alert and note the timezone.

## 2. Capture a read-only snapshot

```bash
./scripts/sysadmin-audit.sh
```

Review uptime, load, available memory, disk space and inodes, failed units, routes, listening sockets, and top processes. The report can reveal private host details; redact it before sharing.

## 3. Identify impact before remediation

- Check whether the symptom affects one process, one host, or multiple hosts.
- Compare current values with a known healthy baseline.
- Look for recent error messages around the reported start time.
- Avoid restarting multiple services at once; that can increase impact and remove useful evidence.

## 4. Record and escalate

Record the command, time, output, and any change made. Follow your organization's incident process and escalate when the host is production-critical or the cause is unclear.
