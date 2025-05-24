{
  description = "Configurations of Benjamin";

  outputs = inputs@{ self, anyrun, chaotic, ghostty, home-manager, hyprlock, hyprpanel, hxs, nixpkgs, nixvim, ... }: {

    packages.x86_64-linux = {
      hxs = hxs.packages.x86_64-linux.default;
      # default = nixpkgs.legacyPackages.x86_64-linux.callPackage ./ags { inherit inputs; };
    };
    # Use the prayers flake as a package
    #packages.prayers = prayers.packages.x86_64-linux.default;

    # nixos config
    nixosConfigurations = {
      "nixos" =
        let
          hostname = "nixos";
          username = "benjamin";
        in
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            asztal = self.packages.x86_64-linux.default;

            # prayers = prayers.packages.x86_64-linux.default;
          };
          modules = [
            ./nixos/nixos.nix
            home-manager.nixosModules.home-manager
            chaotic.nixosModules.default

            {
              users.users.${username} = {
                isNormalUser = true;
                initialPassword = username;
                extraGroups = [
                  "nixosvmtest"
                  "networkmanager"
                  "wheel"
                  "audio"
                  "video"
                  "libvirtd"
                  "docker"
                  "uinput"
                ];
              };
              networking.hostName = hostname;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.${username} = {
                  home.username = username;
                  home.homeDirectory = "/home/${username}";
                  imports = [ ./nixos/home.nix ];
                };
              };
            }
          ];
        };
    };

    # nixos hm config
    homeConfigurations =
      let
        username = "benjamin";
        system = "x86_64-linux";
      in
      {
        "${username}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "${system}";
            overlays = [
              inputs.hyprpanel.overlay
            ];
            config.allowUnfree = true;
          };
          specialArgs = {
            inherit system;
            inherit inputs;
          };
          extraSpecialArgs = {
            inherit system;
            inherit inputs;
            asztal = self.packages.${system}.default;
            # prayers = prayers.packages.${system}.default;
          };
          imports = [ nixvim.HomeManagerModules.nixvim  ];
          modules = [
            ./nixos/home.nix
            hyprlock.homeManagerModules.hyprlock
            anyrun.homeManagerModules.default

            { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }
            ({ pkgs, ... }: {
              nix.package = pkgs.nix;
              home = {
                packages = [
                  (pkgs.writeShellScriptBin "hm" ''
                    ${./symlink.nu} -r
                    home-manager switch --flake .
                    ${./symlink.nu} -a
                  '')
                  inputs.nixvim.packages.${system}.default
                ];

                username = username;
                homeDirectory = "/home/${username}";
              };
            })
          ];
        };
      };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    hyprland.url = "github:hyprwm/Hyprland";
    hyprlock = {
      url = "github:hyprwm/Hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
      #hyprlang.follows = "hyprland.hyprlang";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
      #hyprlang.follows = "hyprland.hyprlang";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
      #hyprlang.follows = "hyprland.hyprlang";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
      #hyprlang.follows = "hyprland.hyprlang";
    };
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";

    matugen.url = "github:InioX/matugen?ref=v2.2.0";

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    hxs = {
      url = "/home/benjamin/repos/rrrr/new/helix";
      flake = true;
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
    };
    walker.url = "github:abenz1267/walker";
  };
}
