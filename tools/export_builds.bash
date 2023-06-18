#!/usr/bin/env bash

declare -r script_path="$(dirname "$0")"
declare -r project_root="$script_path/.."
rm --recursive --force "$project_root"/builds/{linux,windows,macos}
