{ pkgs, config, ... }: {

  home.packages = with pkgs; [ hyprlock ];

  xdg.configFile."hypr/hyprlock.conf".text = ''
    background {
        monitor =
        path = /home/benjamin/Pictures/Wallpapers/MMXX.png
        color = rgb(255,255,255)

        blur_size = 4
        blur_passes = 3
        noise = 0.0117
        contrast = 1.3000
        brightness = 0.8000
        vibrancy = 0.2100
        vibrancy_darkness = 0.0
    }

    input-field {
        monitor =
        size = 250, 50
        outline_thickness = 3
        dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.64 # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true
        outer_color = rgb(255,255,0)
        inner_color = rgb(255,255,255)
        font_color = rgb(0,0,0)
        fade_on_empty = true
        placeholder_text = <i>Password...</i> # Text rendered in the input box when it's empty.
        hide_input = false
        position = 0, 50
        halign = center
        valign = bottom
    }

    # Current time
    label {
        monitor =
        text = cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"
        font_size = 64
        color = rgb(0,0,0)
        font_family = JetBrainsMonoNL
        position = 0, 16
        halign = center
        valign = center
    }

    # User label
    label {
        monitor =
        text = Hey <span text_transform="capitalize" size="larger">$USER</span>
        font_size = 20
        color = rgb(0,0,0)
        font_family = JetBrainsMonoNL
        position = 0, 0
        halign = center
        valign = center
    }


    # Type to unlock
    label {
        monitor =
        text = Type to unlock!
        color = rgb(255,255,255)
        font_family = JetBrainsMonoNL
        font_size = 16
        position = 0, 30
        halign = center
        valign = bottom
    }
  '';
}
