{ pkgs, ... }: {

  imports = [
    /etc/nixos/hardware-configuration.nix
    ./audio.nix
    ./locale.nix
    # ./gnome.nix
    ./hyprland.nix
    # ./laptop.nix
    ./services.nix
  ];
  #default shell
  programs.fish.enable = true;
  users.users.benjamin.shell = pkgs.fish;

  # nix
  documentation.nixos.enable = false; # .desktop
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      trusted-users = [ "benjamin" ];
      experimental-features = "nix-command flakes pipe-operators";
      auto-optimise-store = true;
      extra-substituters = [ "https://hyprland.cachix.org" "https://nyx.chaotic.cx/" "https://anyrun.cachix.org" ];
      extra-trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
      warn-dirty = false;
    };
  };
  # camera
  programs.droidcam.enable = true;

  # virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    podman.enable = false;
    #docker.enable = true;
    #libvirtd.enable = true;
  };

  # dconf
  programs.dconf.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    devenv
    home-manager
    neovim
    git
    wget
    wget2
    yazi
    ripgrep-all
    btop
    psmisc ##fuser
    nh
    nix-output-monitor
    nvd
    dust
  ];

  # services
  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };
    printing.enable = true;
    flatpak.enable = true;

    # plex = {
    #   enable = true;
    #   openFirewall = true;
    # };

    ananicy = {
      enable = true;
      rulesProvider = pkgs.ananicy-rules-cachyos;
      package = pkgs.ananicy-cpp;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    fwupd.enable = true;
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };
  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  # kde connect
  networking.firewall = rec {
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  # network
  networking.networkmanager = {
    # settings = {
    #   device = {
    #     "wifi.scan-rand-mac-address"="no";
    #   };
    # };
    enable = true;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true; # for gnome-bluetooth percentage
  };

  # bootloader
  boot = {
    consoleLogLevel = 0;
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "20%";
      useTmpfs = true;
    };
    initrd = {
      kernelModules = [ "i915" ];
      systemd.enable = true;
      verbose = false;
      # compress = "zstd";
    };
    supportedFilesystems = [ "ntfs fat32" ];
    kernelParams = [ "i915.fastboot=1" "i915.enable_guc=3" "i915.enable_huc=3" "quiet" "vga=current" "loglevel=3" "boot.shell_on_fail" ];

    kernelPackages = pkgs.linuxPackages_cachyos;
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth = rec {
      enable = false;
      # black_hud circle_hud cross_hud square_hud
      # circuit connect cuts_alt seal_2 seal_3
      theme = "lone";
      themePackages = with pkgs; [
        (
          adi1090x-plymouth-themes.override {
            selected_themes = [ theme ];
          }
        )
      ];
    };

    #appimage support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; FLAKE = "/home/benjamin/repos/dotfiles"; }; # Force intel-media-driver

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libcxx
      clang-tools_17
      llvmPackages_17.libstdcxxClang
    ];
  };

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-118n.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };

  system.stateVersion = "24.05";
}
