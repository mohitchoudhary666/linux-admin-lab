# Backups and restore practice

## Create an archive

```bash
mkdir -p "$HOME/backups"
./scripts/backup-create.sh "$HOME/Documents" "$HOME/backups"
tar -tzf "$HOME/backups"/*.tar.gz | head
```

The helper creates a new archive and checks that it can be listed. It does not delete or alter the source. If the destination is inside a directory source, the script refuses to run to avoid archiving its own output.

## Practice restore into a new directory

Use a disposable sample archive and an empty target directory. Inspect the archive list first. Extract with `tar -xzf ARCHIVE -C EMPTY_TARGET` only after confirming the archive contents and destination. Never extract an untrusted archive as root or over an existing system directory.

A local archive on the same disk is not a disaster-recovery backup. Keep a protected copy on separate storage and periodically verify restore procedures.
