{ pkgs, ... }:
{
  xdg.desktopEntries = {
    "lf" = {
      name = "lf";
      noDisplay = true;
    };
    "Balatro" = {
        name = "Balatro";
        exec = "flatpak run --command=bottles-cli  com.usebottles.bottles  run --bottle gameeeeeeeeeeeeee -e /home/benjamin/games/Games/Balatro.v1.0.0N/Balatro.v1.0.0N/Balatro.exe";
        icon = "/home/benjamin/games/Games/Balatro.v1.0.0N/Balatro.v1.0.0N/Balatro OST/Thumbnail.png";
      };
  };

  home.packages = with pkgs; with gnome; [
    # colorscript
    (import ./colorscript.nix { inherit pkgs; })

    # gui
    # obsidian
    (mpv.override { scripts = [mpvScripts.mpris]; })
    libreoffice
    # spotify
    caprine-bin
    d-spy
    github-desktop
    gimp
    transmission_4-gtk
    # discord
    # teams-for-linux
    icon-library
    dconf-editor

    # tools
    steam-run # fhs envs
    bat
    eza
    fd
    ripgrep
    fzf
    libnotify
    killall
    zip
    unzip
    glib
    gnome.gnome-software
    flatpak
    neovide
    yt-dlp
    ffmpeg
    intel-gpu-tools
    foot
    go
    mission-center

    # fun
    glow
    slides
    yabridge
    yabridgectl
    gnome.epiphany
    ungoogled-chromium
  ];


}
