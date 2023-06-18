#!/usr/bin/env bash

declare -r EXPORT_PARAMETER_PATTERN="^(name|platform|export_path)="
declare -r MAC_OSX_PLATFORM="Mac OSX"
declare -r MAC_OSX_RESOURCE_PATH="Giftfall.app/Contents/Resources"

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

    declare license_path="$full_export_directory"
    if [[ "$platform" == "$MAC_OSX_PLATFORM" ]]; then
      license_path+="/$MAC_OSX_RESOURCE_PATH"
      mkdir --parents "$license_path"
    fi
    cp "$project_root"/LICENSE* "$license_path"

    if [[ "$platform" != "$MAC_OSX_PLATFORM" ]]; then
      declare export_archive_path="$full_export_path.zip"
      zip \
        --recurse-paths \
        --junk-paths \
        "$export_archive_path" \
        "$full_export_directory"
    else
      pushd "$full_export_directory" > /dev/null

      declare export_file="$(basename "$full_export_path")"
      zip --recurse-paths --grow "$export_file" "$MAC_OSX_RESOURCE_PATH"

      popd > /dev/null
    fi
  done
