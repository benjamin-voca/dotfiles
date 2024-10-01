{inputs, pkgs, osConfig, ... }:{
  imports = [ inputs.anyrun.homeManagerModules.default ];
    programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.shell
        inputs.anyrun.packages.${pkgs.system}.rink
        inputs.anyrun.packages.${pkgs.system}.kidex
        inputs.anyrun.packages.${pkgs.system}.randr
        inputs.anyrun.packages.${pkgs.system}.stdin
        # inputs.anyrun-nixos-options.packages.${pkgs.system}.default
        # "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}"
      ];
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;
    };
    #extraCss = ''
      #.some_class {
        #background: red;
      #}
    #'';

    extraCss = ''
        * {
          font-family: JetBrainsMono NerdFont;
          font-size: 1.1rem;
        }

        #window,
        #match,
        #plugin,
        #main {
          background: transparent;
        }

        #match:selected {
          background: #504945;
        }

        #match {
          padding: 3px;
          margin: 2px;
          border-radius: 9px;
        }

        #entry, #plugin:hover {
          border-radius: 9px;
        }

        box#main {
          padding: 0px;
          margin-top: 160px;
          box-shadow: 1rem 1rem 3rem 1rem #1C1D1D;
          background: #282828;
          border-radius: 9px;
          border: 2;
          border-color: #282828;
          border-style: solid;
        }
      '';

      # extraConfigFiles."nixos-options.ron".text = let
      #     #               ↓ home-manager refers to the nixos configuration as osConfig
      #     nixos-options = osConfig.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
      #     # merge your options
      #     # options = builtins.toJSON {
      #     #   ":nix" = [nixos-options];
      #     # };
      #     # or alternatively if you wish to read any other documentation options, such as home-manager
      #     # get the docs-json package from the home-manager flake
      #     hm-options = inputs.home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
      #      options = builtins.toJSON {
      #       ":nix" = [nixos-options];
      #       ":hm" = [hm-options];
      #       # ":something-else" = [some-other-option];
      #       ":nall" = [nixos-options hm-options ];
      #     };

      # in ''
      #     Config(
      #         // add your option paths
      #         options: ${options},
      #      )
      # '';
      #extraConfigFiles."some-plugin.ron".text = ''
      #Config(
        #// for any other plugin
        #// this file will be put in ~/.config/anyrun/some-plugin.ron
        #// refer to docs of xdg.configFile for available options
      #)
    #'';
  };
}
