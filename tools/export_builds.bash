#!/usr/bin/env bash

declare -r BLACK="$(tput setaf 237)"
declare -r RED="$(tput setaf 1)"
declare -r GREEN="$(tput setaf 2)"
declare -r YELLOW="$(tput setaf 3)"
declare -r MAGENTA="$(tput setaf 4)"
declare -r RESET="$(tput sgr0)"

declare -r EXPORT_PARAMETER_PATTERN="^(name|platform|export_path)="
declare -r MAC_OSX_PLATFORM="Mac OSX"
declare -r MAC_OSX_RESOURCE_PATH="Giftfall.app/Contents/Resources"

function ansi() {
  declare -r code="$1"
  declare -r text="$2"

  echo -n "$code$text$RESET"
}

function log() {
  declare -r level="$1"

  shift # a shift for the first parameter
  declare -r message="$*"

  declare level_color=""
  if [[ $level == INFO ]]; then
    level_color="$GREEN"
  elif [[ $level == WARNING ]]; then
    level_color="$YELLOW"
  elif [[ $level == ERROR ]]; then
    level_color="$RED"
  fi

  echo "$(ansi "$BLACK" "$(date --rfc-3339=ns)")" \
    "$(ansi "$level_color" "[$level]")" \
    "$message" \
    1>&2
}

log INFO "remove previous builds"
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

    declare log_prefix="$(ansi "$MAGENTA" "[$name]") "
    log INFO "${log_prefix}create the export directory"
    declare full_export_path="$project_root/$export_path"
    declare full_export_directory="$(dirname "$full_export_path")"
    mkdir --parents "$full_export_directory"

    log INFO "${log_prefix}export the build"
    godot \
      --quiet \
      --no-window \
      --path "$project_root" \
      --export "$name" "$export_path"

    log INFO "${log_prefix}copy the licenses"
    declare license_path="$full_export_directory"
    if [[ "$platform" == "$MAC_OSX_PLATFORM" ]]; then
      license_path+="/$MAC_OSX_RESOURCE_PATH"
      mkdir --parents "$license_path"
    fi
    cp "$project_root"/LICENSE* "$license_path"

    if [[ "$platform" != "$MAC_OSX_PLATFORM" ]]; then
      log INFO "${log_prefix}create the archive"
      declare export_archive_path="$full_export_path.zip"
      zip \
        --quiet \
        --recurse-paths \
        --junk-paths \
        "$export_archive_path" \
        "$full_export_directory"
    else
      pushd "$full_export_directory" > /dev/null

      log INFO "${log_prefix}add the licenses to the build"
      declare export_file="$(basename "$full_export_path")"
      zip --quiet --recurse-paths --grow "$export_file" "$MAC_OSX_RESOURCE_PATH"

      popd > /dev/null
    fi
  done
