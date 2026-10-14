#!/usr/bin/env bash
# Create a new gzip tar archive. The source is never removed or modified.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: backup-create.sh SOURCE_PATH DESTINATION_DIRECTORY

Create a timestamped .tar.gz archive of SOURCE_PATH in an existing or
new DESTINATION_DIRECTORY. Existing archives are not overwritten.
EOF
}

if (($# != 2)) || [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit $(( $# == 2 ? 0 : 2 ))
fi

source_path=$1
destination_dir=$2
if [[ ! -e "$source_path" ]]; then
  echo "Source path does not exist: $source_path" >&2
  exit 1
fi
if ! command -v tar >/dev/null 2>&1 || ! command -v realpath >/dev/null 2>&1; then
  echo "This script requires tar and realpath." >&2
  exit 1
fi

mkdir -p -- "$destination_dir"
source_real=$(realpath -- "$source_path")
destination_real=$(realpath -- "$destination_dir")
if [[ -d "$source_real" && ( "$destination_real" == "$source_real" || "$destination_real" == "$source_real"/* ) ]]; then
  echo "Destination cannot be inside the source directory; that would include the archive in itself." >&2
  exit 1
fi

source_parent=$(dirname -- "$source_real")
source_name=$(basename -- "$source_real")
timestamp=$(date -u +%Y%m%dT%H%M%SZ)
archive="$destination_real/${source_name}_${timestamp}.tar.gz"
if [[ -e "$archive" ]]; then
  echo "Refusing to overwrite existing archive: $archive" >&2
  exit 1
fi

temporary=$(mktemp "$destination_real/.linux-admin-backup.XXXXXX")
cleanup() { rm -f -- "$temporary"; }
trap cleanup EXIT
tar -czf "$temporary" -C "$source_parent" -- "$source_name"
tar -tzf "$temporary" >/dev/null
mv -- "$temporary" "$archive"
trap - EXIT
printf 'Backup created and archive listing verified: %s\n' "$archive"
printf 'The source was not deleted or modified. Store a copy on separate media for disaster recovery.\n'
