#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
site_dir="$project_root/site"
yaws_root="$project_root/yaws-yaws-2.3.1"
yaws_binary="$yaws_root/_inst/bin/yaws"
docroot="$yaws_root/_inst/var/yaws/www"

if [[ ! -d "$site_dir" ]]; then
  printf 'Site source directory not found: %s\n' "$site_dir" >&2
  exit 1
fi

if [[ ! -x "$yaws_binary" ]]; then
  printf 'Yaws is not installed at %s. Build and install Yaws first.\n' "$yaws_binary" >&2
  exit 1
fi

mkdir -p "$docroot"
cp -R "$site_dir/." "$docroot/"
printf 'Site copied from %s to %s\n' "$site_dir" "$docroot"