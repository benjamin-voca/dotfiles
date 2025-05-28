{ pkgs, ... }:
let
  transitionList = "left right top bottom wipe wave grow center any outer";
  wallpaperDir = "~/Pictures/Wallpapers";
  chooserFile = "/dev/stdout";
  wppick = pkgs.writeShellScriptBin "wppick" ''
    #!/usr/bin/env bash

    # Configurable variables
    WALLPAPER_DIR=${wallpaperDir}
    TRANSITIONS="${transitionList}"
    CHOOSER_FILE=${chooserFile}

    # Pick a wallpaper using yazi chooser
    raw_paths=$(yazi --chooser-file="$CHOOSER_FILE" "$WALLPAPER_DIR" | while read -r; do printf "%q " "$REPLY"; done)
    paths=$(echo "$raw_paths" | xargs) # Remove trailing space/newlines

    if [[ -n "$paths" ]]; then
      path="$paths"
      echo "Selected wallpaper: $path"

      # Choose a random transition
      transition=$(echo "$TRANSITIONS" | tr ' ' '\n' | shuf -n 1)
      echo "Using transition: $transition"

      # Apply the wallpaper
      swww img -t "$transition" "$path"

      # Export path
      export WALL="$path"
    fi
  '';
in
{
  home.packages = [ wppick ];
}
