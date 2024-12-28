{ inputs, pkgs, ... }:
let
hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
#plugins = inputs.hyprland-plugins.packages.${pkgs.system};

yt = pkgs.writeShellScript "yt" ''
notify-send "Opening video" "$(wl-paste)"
mpv "$(wl-paste)"
'';

playerctl = "${pkgs.playerctl}/bin/playerctl";
brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
pactl = "${pkgs.pulseaudio}/bin/pactl";
in
{
  imports = [./hypreco.nix];
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = [ "X-Preferences" ];
    terminal = false;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland;
    systemd.enable = true;
    xwayland.enable = true;
# plugins = with plugins; [ hyprbars borderspp ];

    settings = {
      exec-once = [
          "ags -b hypr"
          "hyprctl setcursor Qogir 24"
          "systemctl restart pipewire --user"
          # "firefox"
          "flatpak run  io.github.zen_browser.zen"
          "prayers -d"
          "batteryNotify &"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "~/scripts/prayerRepeated.fish &"
      ];
      debug = {
        suppress_errors = true;
      };

      monitor = [
# "eDP-1, 1920x1080, 0x0, 1"
# "HDMI-A-1, 2560x1440, 1920x0, 1"
        ",preferred,auto,1"
      ];

      general = {
        layout = "dwindle";
        resize_on_border = true;
      };

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 1;
      };

      input = {

        resolve_binds_by_sym = 1;
        kb_layout = "us";
        # kb_variant = "dvorak";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "yes";
          drag_lock = true;
          disable_while_typing = false;
        };
        sensitivity = 0;
        float_switch_override_focus = 2;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
# no_gaps_when_only = "yes";
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      windowrule = let
        f = regex: "float, ^(${regex})(.*)$";
        g = rule: regex: "${rule}, ^(${regex})(.*)$";
      in [
          (f "org.gnome.Calculator")
          #(f "org.gnome.Nautilus")
          (f "pavucontrol")
          (f "nm-connection-editor")
          (f "blueberry.py")
          (f "org.gnome.Settings")
          (f "org.gnome.design.Palette")
          (f "Color Picker")
          (f "xdg-desktop-portal")
          (f "xdg-desktop-portal-gnome")
          (f "transmission-gtk")
          (f "com.github.Aylur.ags")
          (f "ViberPC")
          (g "noblur" "firefox")
          (g "noblur" "zen")
          (g "noblur" "discord")
          "float,title:^(ViberPC)(.*)$"
      ];

      bind = let
        binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
      mvfocus = binding "SUPER" "movefocus";
      ws = binding "SUPER" "workspace";
      resizeactive = binding "SUPER CTRL" "resizeactive";
      mvactive = binding "SUPER ALT" "moveactive";
      mvtows = binding "SUPER SHIFT" "movetoworkspace";
      mvtowssil = binding "SUPER ALT" "movetoworkspacesilent";
      e = "exec, ags -b hypr";
      sws = "togglespecialworkspace";
      msws = "movetoworkspacesilent";
      arr = [0 1 2 3 4 5 6 7 8 9];
      in [

          "Super,Escape,exec, ~/switchkb.fish"
          ", XF86Calculator,exec, swappy -f ~/Downloads/dvorak.png"
          "CTRL SHIFT, R,  ${e} quit; ags -b hypr"
          "SUPER, R,       ${e} -t launcher"
          "SUPER, Tab,     ${e} -t overview"
          ",XF86PowerOff,  ${e} -r 'powermenu.shutdown()'"
          ",XF86Launch4,   ${e} -r 'recorder.start()'"
          ",Print,         ${e} -r 'recorder.screenshot()'"
          "SHIFT,Print,    ${e} -r 'recorder.screenshot(true)'"
          "SUPER, Q, exec, ghostty" # xterm is a symlink, not actually xterm
          # "SUPER Alt, Q, exec,  ghostty" # xterm is a symlink, not actually xterm
          # "SUPER, W, exec, firefox"
          "SUPER, W, exec, flatpak run io.github.zen_browser.zen"
          "SUPER Control, W, exec, flatpak run  io.github.zen_browser.zen --private-window"
          "SUPER, O, exec, ghostty -e yazi"
          ''ControlSuperShift,S,exec,grim -g "$(slurp -d)" "tmp.png" && tesseract -l eng "tmp.png" - | wl-copy && rm "tmp.png"''
          "SuperShift,S,exec, fish -c 'grim -g (slurp) - | satty -f -' "
          "SuperShiftAlt,S,exec, fish -c 'grim - | satty -f -' "
          "Super, V, exec, cliphist list | anyrun --show-results-immediately true --plugins ${inputs.anyrun.packages.${pkgs.system}.stdin}/lib/libstdin.so | cliphist decode | wl-copy"
# youtube
          ", XF86Launch1,  exec, ${yt}"
          "SUPER, Q, exec, systemctl shutdown now"          
          "ALT, Tab, focuscurrentorlast"
          "CTRL ALT, Delete, exit"
          "ALT, Q, killactive"
          "Control ALT, Q, exec, hyprctl kill"
          "SUPER, F, togglefloating"
          "ALT, Return, fullscreen"
          # "ALT Control, Return, fakefullscreen"
          "SUPER, P, togglesplit"
          "SUPER, N, exec, neovide"
          "SUPER Alt, N, exec, ghostty -e hx "
          "Super, Super_L, exec, ags -b hypr -t launcher || anyrun"
          "SUPER, K, exec, ~/scripts/prayers.fish"
          "SUPER, E, exec, nautilus"
          "Super, L, exec, hyprlock"

          "Super, S, ${sws},terminal"
          "Super Alt, O, ${sws},yazi"
          ", XF86Favorites,${sws},amberol"
          "Super, A, ${sws},thunderbird"
          "Super, X, ${sws}, pavu"
          "Super Alt, X, ${sws}, blueman"
          "Super, Z, ${sws},tasks"
          "ControlSuper, S, ${sws}, termAlt"
          "ControlSuper, A, ${sws}, thunderbirdAlt"
          "AltSuper, S, ${msws}, termAlt"
          "AltSuper, A, ${msws}, thunderbirdAlt"
          "Control Shift, Escape, ${sws}, taskManager"


          (mvfocus "k" "u")
          (mvfocus "j" "d")
          (mvfocus "l" "r")
          (mvfocus "h" "l")
          (ws "left" "e-1")
          (ws "right" "e+1")
          (mvtows "left" "e-1")
          (mvtows "right" "e+1")
          (resizeactive "k" "0 -20")
          (resizeactive "j" "0 20")
          (resizeactive "l" "20 0")
          (resizeactive "h" "-20 0")
          (mvactive "k" "0 -20")
          (mvactive "j" "0 20")
          (mvactive "l" "20 0")
          (mvactive "h" "-20 0")
          ]
          ++ (map (i: ws (toString i) (toString i)) arr)
          ++ (map (i: mvtows (toString i) (toString i)) arr)
          ++ (map (i: mvtowssil (toString i) (toString i)) arr);

      workspace = let

        special = name: cmd:  "special:${name}, on-created-empty:${cmd}";
      in [
          (special "terminal" "ghostty") 
          (special "yazi" " ghostty -e yazi") 
          (special "orari" "org.libreoffice.LibreOffice  ~/Documents/shkolle/Orari_Sem_2.xlsx") 
          (special "amberol " " amberol ~/Music/") 
          (special "monitor" "ghostty -e btop &") 
          (special "tasks" "io.github.mrvladus.List") 
          (special "thunderbird" " [fakefullscreen] org.mozilla.Thunderbird") 
          (special "pavu" " pavucontrol") 
          (special "blueman" " blueman-manager") 
          (special "taskManager" "ghostty -e btop &") 
      ]
          #++ (map (i: special (toString i) (toString i)))
      ;

      bindle = [
          ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
          ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
          ",XF86KbdBrightnessUp,   exec, ${brightnessctl} -d asus::kbd_backlight set +1"
          ",XF86KbdBrightnessDown, exec, ${brightnessctl} -d asus::kbd_backlight set  1-"
          ",XF86AudioRaiseVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
      ];

      bindl =  [
          ",XF86AudioPlay,    exec, ${playerctl} play-pause"
          ",XF86AudioStop,    exec, ${playerctl} pause"
          ",XF86AudioPause,   exec, ${playerctl} pause"
          ",XF86AudioPrev,    exec, ${playerctl} previous"
          ",XF86AudioNext,    exec, ${playerctl} next"
          ",XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
          ",switch:on:Lid Switch, exec, systemctl suspend && hyprlock"
      ];

      bindm = [
          "SUPER, mouse:273, resizewindow"
          "SUPER, mouse:272, movewindow"
      ];

      decoration = {
        drop_shadow = "yes";
        shadow_range = 8;
        shadow_render_power = 2;
        "col.shadow" = "rgba(00000044)";

        dim_inactive = false;

        blur = {
          enabled = true;
          size = 7;
          passes = 4;
          new_optimizations = "on";
          noise = 0;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.04, 0.8, 0.3, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
            "specialWorkspace, 1, 6, default, slidevert"
            "layers, 1, 6, default,popin 60%"
        ];
      };
      layerrule = [
          "blur, eww"
          "ignorealpha 0.8, eww"
          "noanim, noanim"
          "blur, noanim"
          "blur, gtk-layer-shell"
          "ignorezero, gtk-layer-shell"
          "blur, launcher"
          "ignorealpha 0.5, launcher"
          "blur, notifications"
          "ignorealpha 0.69, notifications"

          "blur, bar"
          "ignorealpha 0.10, bar"
          "blur, corner.*"
          "ignorealpha 0.10, corner.*"
          "blur, dock"
          "ignorealpha 0.10, dock"
          "blur, indicator.*"
          "ignorealpha 0.10, indicator.*"
          "blur, overview"
          "ignorealpha 0.10, overview"
          "blur, cheatsheet"
          "ignorealpha 0.10, cheatsheet"
          "blur, sideright"
          "ignorealpha 0.10, sideright"
          "noanim, sideright"
          "blur, sideleft"
          "noanim, sideleft"
          "xray, sideright"
          "ignorealpha 0.10, sideleft"
          "blur, indicatorundefined"
          "ignorealpha 0.10, indicatorundefined"
          "blur, osk"
          "ignorealpha 0.10, osk"
          "blur, session"
          "xray 1, session"
          ];

      plugin = {
        hyprbars = {
          bar_color = "rgb(2a2a2a)";
          bar_height = 28;
          col_text = "rgba(ffffffdd)";
          bar_text_size = 11;
          bar_text_font = "Ubuntu Nerd Font";

          buttons = {
            button_size = 0;
            "col.maximize" = "rgba(ffffff11)";
            "col.close" = "rgba(ff111133)";
          };
        };
      };
    };
  };
}
