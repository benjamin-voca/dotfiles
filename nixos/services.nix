{ pkgs, ... }:{
  systemd.services = {
#     batteryDaemon = {
#       description = "Battery Warning Service";
#       after = [ "graphical.target" ];
#       script = ''
# #!/bin/bash

# # Check if the system is a laptop
# is_laptop() {
#     if [ -d /sys/class/power_supply/ ]; then
#         for supply in /sys/class/power_supply/*; do
#             if [ -e "$supply/type" ]; then
#                 type=$(cat "$supply/type")
#                 if [ "$type" == "Battery" ]; then
#                     return 0  # It's a laptop
#                 fi
#             fi
#         done
#     fi
#     return 1  # It's not a laptop
# }

# if is_laptop; then

# while true; do
#     battery_status=$(cat /sys/class/power_supply/BAT1/status)
#     battery_percentage=$(cat /sys/class/power_supply/BAT1/capacity)

#     if [ "$battery_status" == "Discharging" ] && [ "$battery_percentage" -le 20 ]; then
#         ${pkgs.libnotify}/bin/notify-send -u CRITICAL "Battery Low" "Battery is at $battery_percentage%. Connect the charger."
#     fi

#     if [ "$battery_status" == "Charging" ] && [ "$battery_percentage" -ge 95 ]; then
#         ${pkgs.libnotify}/bin/notify-send -u NORMAL "Battery Charged" "Battery is at $battery_percentage%. You can unplug the charger."
#     fi

#     sleep 300  # Sleep for 5 minutes before checking again
#   done

# fi
#             '';
#       wantedBy = [ "default.target" ];
#       serviceConfig = {
#         Type = "simple";
#         Exec = "/usr/bin/env bash -c $script";
#       };
#     };
  };
}
