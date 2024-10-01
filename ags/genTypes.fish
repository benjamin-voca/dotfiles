#!/usr/bin/env fish
rm types
ln -s (fd home-manager-path /nix/store -l -t d | head -n 1 | awk -F ' ' '{print $9}')/share/com.github.Aylur.ags/types/ types
