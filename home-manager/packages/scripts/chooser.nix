{ pkgs, ... }:
let
  wppick = pkgs.writeShellScriptBin "wppick" ''
  paths=$(yazi --chooser-file=/dev/stdout ~/Pictures/Wallpapers | while read -r; do printf "%q " "$REPLY"; done)

# Ensure there's no trailing space or newline in the path
paths=$(echo "$paths" | xargs)

if [[ -n "$paths" ]]; then
  path="$paths"
  echo "$path"
  swww img "$path"
  export WALL="$path"
fi
'';
in
{
  home.packages = [ wppick ];
}
