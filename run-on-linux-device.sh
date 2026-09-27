#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
yaws_root="$project_root/yaws-yaws-2.3.1"
yaws_binary="$yaws_root/_inst/bin/yaws"

if [[ "$(uname -s)" != Linux ]]; then
  printf 'This monitoring endpoint requires Linux (/proc and /sys).\n' >&2
  exit 1
fi

for command_name in erl erlc make gcc; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'Missing build command: %s\nInstall Erlang/OTP 25+ and the Yaws build dependencies first.\n' "$command_name" >&2
    exit 1
  fi
done

if [[ ! -f "$yaws_root/configure" ]]; then
  if ! command -v autoreconf >/dev/null 2>&1; then
    printf 'configure is missing; install autoconf and run autoreconf -fi first.\n' >&2
    exit 1
  fi
  (cd "$yaws_root" && autoreconf -fi)
fi

(
  cd "$yaws_root"
  sh ./configure --prefix="$yaws_root/_inst"
  make -j"$(getconf _NPROCESSORS_ONLN)"
  make install
)

bash "$project_root/sync-site.sh"

if "$yaws_binary" --status >/dev/null 2>&1; then
  "$yaws_binary" --hup
else
  "$yaws_binary" --daemon --heart
fi

"$yaws_binary" --wait-started=15
printf 'Yaws is running. Open http://127.0.0.1:8000/monitor.html on this device.\n'