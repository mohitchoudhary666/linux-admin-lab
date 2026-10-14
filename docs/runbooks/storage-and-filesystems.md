# Storage and filesystems

## Inspect space and inodes

```bash
df -hP
df -iP
du -xhd1 /var 2>/dev/null | sort -h
lsblk -f
findmnt
```

`df` reports filesystem-level capacity; `du` estimates space used by directory entries. A filesystem can run out of inodes while still having free bytes. `du` may need elevated read access for a complete view; inspect its target before using `sudo`.

## Find large files without deleting them

```bash
find /var/log -xdev -type f -size +100M -printf '%s %p\n' 2>/dev/null | sort -n
```

Investigate ownership, service, and retention policy before cleanup. Do not remove active logs or files managed by a package/service. Prefer the service's documented log rotation and retention controls.

## Mounts and devices

Use `lsblk -f`, `findmnt`, and `cat /etc/fstab` to understand the device, filesystem, mount point, and persistent mount configuration. Editing `/etc/fstab` can prevent boot if incorrect; back it up and validate changes in a lab first.
