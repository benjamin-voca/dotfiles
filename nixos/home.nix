{ pkgs, config, inputs, ... }: {
  imports = [
    ../home-manager/ags.nix
    ../home-manager/anyrun.nix
    ../home-manager/browser.nix
    ../home-manager/hyprland
    ../home-manager/packages
    ../home-manager/shell
    ../home-manager/theme.nix
    ../home-manager/wezterm.nix
  ];

  news.display = "show";

  targets.genericLinux.enable = true;

  home = {
    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      BAT_THEME = "base16";
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
      CARGO_TARGET_DIR = "${config.home.homeDirectory}/.cargo/cargo-target/";
      PAGER = "${pkgs.bat}/bin/bat";
      EDITOR = "${inputs.hxs.packages.x86_64-linux.default}/bin/hx";
      GRAVEYARD = "${config.home.homeDirectory}/.local/share/Graveyard/";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "${config.home.homeDirectory}/.local/share/go/bin"
    ];
  };
  xdg = {
    mimeApps = {
      defaultApplications = {
        "x-scheme-handler/http" = "io.github.zen_browser.zen.desktop";
        "x-scheme-handler/https" = "io.github.zen_browser.zen.desktop";
      };
    };
  };

  gtk.gtk3.bookmarks =
    let
      home = config.home.homeDirectory;
    in
    [
      "file://${home}/Documents"
      "file://${home}/Music"
      "file://${home}/Pictures"
      "file://${home}/Videos"
      "file://${home}/Downloads"
      "file://${home}/Desktop"
      "file://${home}/Work"
      "file://${home}/Documents/shkolle/programim School"
      "file://${home}/Projects"
      "file://${home}/.config Config"
      "file://${home}/.local/share Local"
    ];

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    mako = {
      enable = false;
      anchor = "top-center";
      layer = "overlay";
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
