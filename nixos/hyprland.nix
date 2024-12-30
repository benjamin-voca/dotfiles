{
  pkgs,
  inputs,
  # config,
  # asztal,
  ...
}: {
  services.xserver.displayManager.startx.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security = {
    polkit.enable = true;
    pam.services = {
      ags = {};
    };

    sudo.extraRules = [
      {
        users = [ "benjamin" ];
        commands = [{
          command = "${pkgs.btop}/bin/btop";
          options = [ "NOPASSWD" ];
        }];
      }
    ];
  };

  environment.systemPackages = with pkgs;
  [
    # gnome.loupe
    adwaita-icon-theme
    nautilus
    baobab
    # gnome-text-editor
    # gnome-calendar
    # gnome-boxes
    # gnome-system-monitor
    # gnome-control-center
    # gnome-weather
    # gnome-calculator
    # gnome-clocks
    gnome-software # for flatpak
    wl-gammactl
    wl-clipboard
    wayshot
    pavucontrol
    brightnessctl
    swww
    jq
    hyprshot
    tesseract
  ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };
  };


  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "benjamin";
      };
      default_session = {
        command = " ${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${pkgs.hyprland}/bin/Hyprland";
        user = "greeter";
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d '/var/cache/greeter' - greeter greeter - -"
  ];

  system.activationScripts.wallpaper = ''
    PATH=$PATH:${pkgs.coreutils}/bin:${pkgs.jq}/bin
    CACHE="/var/cache/greeter"
    OPTS="$CACHE/options.json"
    HOME="/home/$(find /home -maxdepth 1 -printf '%f\n' | tail -n 1)"

    cp /home/benjamin/.cache/ags/options.json /var/cache/greeter/options.json
    chown greeter:greeter /var/cache/greeter/options.json

    BG=$(cat /var/cache/greeter/options.json | jq -r '.wallpaper // "/home/benjamin/.config/background"')
    cp $BG /var/cache/greeter/background
    chown greeter:greeter /var/cache/greeter/background
  '';
}
