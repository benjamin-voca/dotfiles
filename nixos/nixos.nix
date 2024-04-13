{ pkgs, ... }: {

  imports = [
    /etc/nixos/hardware-configuration.nix
# ./audio.nix
      ./locale.nix
# ./gnome.nix
      ./hyprland.nix
# ./laptop.nix
  ./services.nix
  ];
#default shell
  users.users.benjamin.shell = pkgs.nushell;

# nix
  documentation.nixos.enable = false; # .desktop
    nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

# camera
  programs.droidcam.enable = true;

# virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    podman.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

# dconf
  programs.dconf.enable = true;

# packages
  environment.systemPackages = with pkgs; [
    home-manager
      neovim
      zoxide
      git
      wget
      yazi
      ripgrep
      btop
      psmisc
  ];

# services
  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };
    printing.enable = true;
    flatpak.enable = true;

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
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
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
  networking.networkmanager.enable = true;

# bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true; # for gnome-bluetooth percentage
  };

# bootloader
  boot = {
    tmp.cleanOnBoot = true;
    initrd.kernelModules = [ "i915" ];
    supportedFilesystems = [ "ntfs fat32" ];
    kernelParams = [ "i915.fastboot=1" "quiet" "splash" ];
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth = rec {
      enable = true;
# black_hud circle_hud cross_hud square_hud
# circuit connect cuts_alt seal_2 seal_3
      theme = "lone";
      themePackages = with pkgs; [(
          adi1090x-plymouth-themes.override {
          selected_themes = [ theme ];
          }
          )];
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
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

  system.stateVersion = "23.05";
}
