# Networking

## Inspect local network state

```bash
ip -brief address
ip route
getent hosts example.com
ss -tuln
```

Check interface state and address, the default route, name resolution, and local listening sockets. `ss -tuln` inspects the local host; this project does not scan remote systems.

## Troubleshooting order

1. Is the interface up and configured?
2. Is the expected route present?
3. Can the host resolve the required name?
4. Is a local process listening on the expected address and port?
5. Are local firewall and upstream network rules consistent with the intended service?

Do not expose a management port to the public internet to “test” it. Use your organization's approved network path and security rules.
