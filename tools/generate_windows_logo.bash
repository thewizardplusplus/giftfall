#!/usr/bin/env bash

# https://docs.godotengine.org/en/3.5/tutorials/export/changing_application_icon_for_windows.html#creating-an-ico-file
declare -r script_path="$(dirname "$0")"
convert \
  "$script_path/../docs/logo/logo_256x256.png" \
  -define icon:auto-resize=256,128,64,48,32,16 \
  "$script_path/../docs/logo/logo.ico"
