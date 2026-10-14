#!/usr/bin/env bash
# Read-only Linux host inventory. The output can contain private host details.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: sysadmin-audit.sh [--output FILE]

Print a read-only host inventory. If --output is given, save it to FILE.
The report can contain hostnames, IP addresses, usernames, and process details.
EOF
}

output_file=""
while (($#)); do
  case "$1" in
    --output)
      if (($# < 2)) || [[ -z "$2" ]]; then
        echo "--output requires a file path" >&2
        exit 2
      fi
      output_file=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -n "$output_file" ]]; then
  output_dir=$(dirname -- "$output_file")
  if [[ ! -d "$output_dir" ]]; then
    echo "Output directory does not exist: $output_dir" >&2
    exit 1
  fi
  if [[ -e "$output_file" ]]; then
    echo "Refusing to overwrite existing file: $output_file" >&2
    exit 1
  fi
  umask 077
  report_tmp=$(mktemp "${output_file}.XXXXXX")
  trap 'rm -f -- "$report_tmp"' EXIT
  exec >"$report_tmp"
fi

section() { printf '\n===== %s =====\n' "$1"; }
run_if_available() {
  local command_name=$1
  shift
  if command -v "$command_name" >/dev/null 2>&1; then
    "$@" 2>&1 || printf '[command returned a non-zero status]\n'
  else
    printf '[%s is not installed]\n' "$command_name"
  fi
}

section "Report metadata"
printf 'Generated: %s\n' "$(date -Is 2>/dev/null || date)"
printf 'Hostname:  %s\n' "$(hostname 2>/dev/null || printf unknown)"
printf 'User:      %s\n' "$(id -un 2>/dev/null || printf unknown)"

section "Operating system and kernel"
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  printf '%s %s (%s)\n' "${PRETTY_NAME:-Linux}" "${VERSION_ID:-}" "${ID:-unknown}"
fi
run_if_available uname uname -a
run_if_available uptime uptime

section "CPU and memory"
run_if_available nproc nproc
run_if_available lscpu lscpu
if [[ -r /proc/meminfo ]]; then
  awk '/^(MemTotal|MemAvailable|SwapTotal|SwapFree):/ {printf "%s %s %s\n", $1, $2, $3}' /proc/meminfo
else
  run_if_available free free -h
fi

section "Filesystem capacity and inodes"
run_if_available df df -hP
run_if_available df df -iP

section "Failed systemd units"
if command -v systemctl >/dev/null 2>&1; then
  systemctl --failed --no-pager 2>&1 || printf '[systemd status unavailable]\n'
else
  printf '[systemctl is not installed]\n'
fi

section "Network interfaces and routes"
run_if_available ip ip -brief address
run_if_available ip ip route
printf 'Resolver configuration:\n'
if [[ -r /etc/resolv.conf ]]; then
  sed -n '1,20p' /etc/resolv.conf
else
  printf '[/etc/resolv.conf is not readable]\n'
fi

section "Listening TCP/UDP sockets"
run_if_available ss ss -tuln

section "Top processes by CPU"
run_if_available ps ps -eo pid,ppid,user,stat,%cpu,%mem,comm --sort=-%cpu

if [[ -n "$output_file" ]]; then
  mv -- "$report_tmp" "$output_file"
  trap - EXIT
  printf 'Report saved to %s (permissions restricted by umask 077).\n' "$output_file" >&2
fi
