{ pkgs, ... }: {


  # imports = [ pkgs.nix-minecraft.modules.bukkit-plugins ];
  #shutdown as normal user
  environment.etc."polkit-1/rules.d/50-shutdown.rules".text = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.login1.reboot" ||
          action.id == "org.freedesktop.login1.power-off" ||
          action.id == "org.freedesktop.login1.suspend" ||
          action.id == "org.freedesktop.login1.hibernate") {
        return subject.isInGroup("wheel") ? polkit.Result.YES : polkit.Result.NO;
      }
    });
  '';
  security = {
    polkit.enable = true;
  };
  services = {
  /*

    bukkit-plugins = {
      enable = true;
      plugins = {
        geyser = {
          package = pkgs.nix-minecraft.pkgs.geysermc;
          settings = {
            # Add any specific GeyserMC configurations here
          };
        };
        # Add more plugins as needed
      };
    };
    minecraft-server = {
      enable = true;
      eula = true;
      declarative = true;

      package = pkgs.velocityServers.velocity;

      servers = {
        main-server = {
          enable = true;
          package = pkgs.fabricServers.fabric;
        };
      };

      restartIfChanged = true;
      serviceConfig = {
        Restart = "always";
        RestartSec = "5s";
      };
      serverProperties = {
        gamemode = "survival";
        difficulty = "hard";
        simulation-distance = 10;
        view-distance = 10;
        level-seed = "4";
        level-name = "Namek";
        use-native-transport = true;
      };

      whitelist = {
        vimjoyer = "3f96da12-a55c-4871-8e26-09256adac319";
      };

      jvmOpts = ''
        -Xms4G -Xmx8G
        -XX:+UseG1GC
        -XX:MaxGCPauseMillis=50
        -XX:G1NewSizePercent=30
        -XX:G1MaxNewSizePercent=40
        -XX:G1HeapRegionSize=8M
        -XX:InitiatingHeapOccupancyPercent=15
        -XX:G1MixedGCLiveThresholdPercent=90
        -XX:+UnlockExperimentalVMOptions
      '';
    };*/
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    '';
    udev.packages = [
      pkgs.android-udev-rules
    ];

    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };

    xserver = {
      enable = true;
      # driSupport = true;
      # driSupportVersion = "2"; # or "3"
    };
    kanata = {
      enable = true;
      keyboards = {
        internalKeyboard = {
          devices = [
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
            "/dev/input/by-id/usb-Framework_Laptop_16_Keyboard_Module_-_ANSI_FRAKDKEN0100000000-event-kbd"
            "/dev/input/by-id/usb-Framework_Laptop_16_Keyboard_Module_-_ANSI_FRAKDKEN0100000000-if02-event-kbd"
          ];
          extraDefCfg = "process-unmapped-keys yes";
          /*
          config = ''
            (defsrc
             caps a s d f j k l ;
            )
            (defvar
             tap-time 150
             hold-time 200
            )
            (defalias
             caps (tap-hold 200 200 esc lctl)
             a (tap-hold $tap-time $hold-time a lmet)
             s (tap-hold $tap-time $hold-time s lalt)
             d (tap-hold $tap-time $hold-time d lsft)
             f (tap-hold $tap-time $hold-time f lctl)
             j (tap-hold $tap-time $hold-time j rctl)
             k (tap-hold $tap-time $hold-time k rsft)
             l (tap-hold $tap-time $hold-time l ralt)
             ; (tap-hold $tap-time $hold-time ; rmet)
            )

            (deflayer base
             @caps @a  @s  @d  @f  @j  @k  @l  @;
            )
          '';
          */
          config = ''
            (defsrc
             caps
            )

            (defvar
             tap-time 150
             hold-time 200
            )
            (defalias
             caps (tap-hold 200 200 esc lctl)
            )
            (deflayer base
             @caps
            )
            '';
        };
      };
    };
  };
}
