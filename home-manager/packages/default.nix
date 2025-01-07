{ pkgs, inputs, ... }:
let btl_cmd = "flatpak run --command=bottles-cli  com.usebottles.bottles  run --bottle Gaming -e "; in
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
      exec = "${btl_cmd} /home/benjamin/games/Games/Balatro.v1.0.1f/Balatro.v1.0.1f/Balatro.exe";
      icon = "/home/benjamin/games/Games/Balatro.v1.0.1f/Balatro.v1.0.1f/Balatro OST/Thumbnail.png";
    };
    "Satty" = {
      name = "Satty";
      exec = "satty -f %f";
      icon = "application-default-icon";
      terminal = false;
      type = "Application";
      mimeType = [ "image/png" "image/jpeg" "image/jpg" "image/gif" "image/bmp" "image/webp" "image/tiff" "image/x-icon" "image/svg+xml" ];
    };
    "Krunker" = {
      name = "Krunker";
      exec = "/home/benjamin/scripts/setup.AppImage";
      icon = "/home/benjamin/scripts/krunker.png";
      terminal = false;
      type = "Application";
    };
    "Vampire Survivors" = {
      name = "Vampire Survivors";
      exec = "${btl_cmd} /home/benjamin/games/Games/Vampire.Survivors.v1.12.107/Vampire.Survivors.v1.12.107/Vampire Survivors.exe";
      icon = "/home/benjamin/scripts/vamp.jpeg";
      terminal = false;
    };
    "Hades 2" = {
      name = "Hades 2";
      exec = "${btl_cmd} /home/benjamin/games/Games/Hades.II.v0.95285.Early.Access/Hades.II.v0.95285.Early.Access/Ship/Hades2.exe";
      icon = "/home/benjamin/games/Games/Hades.II.v0.95285.Early.Access/Hades.II.v0.95285.Early.Access/Ship/game.ico";
      terminal = false;
    };
  };

  home.packages = with pkgs;  [

    inputs.user-shell.packages.x86_64-linux.default
    inputs.ghostty.packages.x86_64-linux.default

    # gui
    # obsidian
    (mpv.override { scripts = [ mpvScripts.mpris ]; })
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
    #cli
    xlsx2csv
    just

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
