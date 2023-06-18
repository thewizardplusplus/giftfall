#!/usr/bin/env bash

declare -r EXPORT_PARAMETER_PATTERN="^(name|platform|export_path)="

declare -r script_path="$(dirname "$0")"
declare -r project_root="$script_path/.."
rm --recursive --force "$project_root"/builds/{linux,windows,macos}

cat "$project_root/export_presets.cfg" \
  | grep --perl-regexp "$EXPORT_PARAMETER_PATTERN" \
  | sed --regexp-extended "s/$EXPORT_PARAMETER_PATTERN//;s/^\"//;s/\"$//" \
  | paste --serial --delimiters '\t\t\n' \
  | while read -r; do
    declare name="$(echo "$REPLY" | cut -f1)"
    declare platform="$(echo "$REPLY" | cut -f2)"
    declare export_path="$(echo "$REPLY" | cut -f3)"

    declare full_export_path="$project_root/$export_path"
    declare full_export_directory="$(dirname "$full_export_path")"
    mkdir --parents "$full_export_directory"

    godot --no-window --path "$project_root" --export "$name" "$export_path"
  done
