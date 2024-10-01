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
    "lf" = {
      name = "lf";
      noDisplay = true;
    };
    "Balatro" = {
        name = "Balatro";
        exec = "flatpak run --command=bottles-cli  com.usebottles.bottles  run --bottle gameeeeeeeeeeeeee -e /home/benjamin/games/Games/Balatro.v1.0.1f/Balatro.v1.0.1f/Balatro.exe";
        icon = "/home/benjamin/games/Games/Balatro.v1.0.0F/Balatro.v1.0.0F/Balatro OST/Thumbnail.png";
    };
    "Door Kickers" = {
        name = "Door Kickers";
        exec = "flatpak run --command=bottles-cli  com.usebottles.bottles  run --bottle gameeeeeeeeeeeeee -e /home/benjamin/games/Games/Door.Kickers.2.Task.Force.North.v0.36/Door.Kickers.2.Task.Force.North.v0.36/DoorKickers2.exe";
        icon = "/home/benjamin/games/Games/Door.Kickers.2.Task.Force.North.v0.36/Door.Kickers.2.Task.Force.North.v0.36/DK2.jpg";
    };

    "Kingdom Rush" = {
        name = "Kingdom Rush";
        exec = "flatpak run --command=bottles-cli  com.usebottles.bottles  run --bottle gameeeeeeeeeeeeee -e /home/benjamin/.var/app/com.usebottles.bottles/data/bottles/bottles/gameeeeeeeeeeeeee/drive_c/Games/Kingdom Rush Vengeance/Kingdom Rush Vengeance.exe";
        icon = "/home/benjamin/games/Games/Kingdom.Rush.Vengeance.Hammerhold.Campaign-TENOKE/kingdomRush.jpg";
    };
    "Battlesector" = {
        name="Warhammer 40K Battlesector";
        exec=''flatpak run --command=bottles-cli com.usebottles.bottles run -p "Warhammer 40K Battlesector" -b "gameeeeeeeeeeeeee" -- %u'';
        type="Application";
        icon="/home/benjamin/.var/app/com.usebottles.bottles/data/bottles/bottles/gameeeeeeeeeeeeee/icons/Warhammer 40K Battlesector.png";
        comment="Launch Warhammer 40K Battlesector using Bottles";
      };
    "Satty" = {
        name="Satty";
        exec="satty -f %f";
        icon="application-default-icon";
        terminal=false;
        type="Application";
        mimeType=["image/png" "image/jpeg" "image/jpg" "image/gif" "image/bmp" "image/webp" "image/tiff" "image/x-icon" "image/svg+xml"];
    };
    "Songs Of Conquest" = {
        name="Songs Of Conquest";
        exec="flatpak run --command=bottles-cli com.usebottles.bottles run -p SongsOfConquest -b gameeeeeeeeeeeeee -- %u";
        type="Application";
        terminal=false;
        icon="/home/benjamin/.var/app/com.usebottles.bottles/data/bottles/bottles/gameeeeeeeeeeeeee/icons/SongsOfConquest.png";
        comment="Launch SongsOfConquest using Bottles.";
    };
  };

  home.packages = with pkgs;  [
   
    # gui
    # obsidian
    (mpv.override { scripts = [mpvScripts.mpris]; })
    libreoffice
    amberol

    #langs
    d-spy
    transmission_4-gtk
    # discord
    # teams-for-linux
    fastfetch
    calcurse

    vscode-extensions.vadimcn.vscode-lldb    
    # tools
    # steam-run # fhs envs
    any-nix-shell
    blueman
    mount-zip
    parallel
    tealdeer
    bat
    eza
    fd
    ripgrep
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
    #TODO: REMOVE
    mission-center
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
