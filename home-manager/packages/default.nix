{ pkgs, ... }:
{
imports = [
    ./scripts/blocks.nix
    ./scripts/nx-switch.nix
    ./scripts/vault.nix
    ./scripts/gamemode.nix
    ./scripts/batt.nix
  ];

  xdg.desktopEntries = {
    "Balatro" = {
        name = "Balatro";
        exec = "flatpak run --command=bottles-cli  com.usebottles.bottles  run --bottle gameeeeeeeeeeeeee -e /home/benjamin/games/Games/Balatro.v1.0.1f/Balatro.v1.0.1f/Balatro.exe";
        icon = "/home/benjamin/games/Games/Balatro.v1.0.0F/Balatro.v1.0.0F/Balatro OST/Thumbnail.png";
    };
    "Satty" = {
        name="Satty";
        exec="satty -f %f";
        icon="application-default-icon";
        terminal=false;
        type="Application";
        mimeType=["image/png" "image/jpeg" "image/jpg" "image/gif" "image/bmp" "image/webp" "image/tiff" "image/x-icon" "image/svg+xml"];
    };
    "Krunker" = {
        name="Krunker";
        exec="/home/benjamin/scripts/setup.AppImage";
        icon="/home/benjamin/scripts/krunker.png";
        terminal=false;
        type="Application";
    };
  };

  home.packages = with pkgs;  [
   
    # gui
    # obsidian
    (mpv.override { scripts = [mpvScripts.mpris]; })
    libreoffice
    amberol
    pywalfox-native

    #langs
    d-spy
    transmission_4-gtk
    # discord
    # teams-for-linux
    fastfetch
    calcurse

    #NB
    nb
    socat
    pandoc
    tig
    w3m

    vscode-extensions.vadimcn.vscode-lldb    
    # tools
    bat-extras.batman
    # steam-run # fhs envs
    any-nix-shell
    blueman
    mount-zip
    parallel
    lazygit
    tealdeer
    bat
    eza
    fd
    ripgrep-all
    cliphist
    bluetuith
    fzf
    libnotify
    killall
    imagemagick
    ouch
    glib
    flatpak
    neovide
    kalker
    yt-dlp
    grim
    satty
    ffmpeg-full
    intel-gpu-tools
    foot
    go
    miniserve
    openssl
    pkg-config

    # fun
    glow
    slides
    yabridge
    yabridgectl
  ];
}
