{ pkgs, lib, ... }: let
  ifLinux = lib.mkIf pkgs.stdenv.isLinux;

  deps = with pkgs; with nodePackages_latest; [
    # js, html
    vscode-langservers-extracted
    tailwindcss-language-server
    typescript-language-server
    eslint
    typescript

    # markup
    marksman
    markdownlint-cli
    taplo # toml
    yaml-language-server

    # python
    ruff
    ruff-lsp
    pyright

    # bash
    shfmt
    bash-language-server
  ];
in {
  xdg = {
    configFile.nvim.source = ../nvim;
    desktopEntries."nvim" = ifLinux {
      name = "NeoVim";
      comment = "Edit text files";
      icon = "nvim";
      exec = "xterm -e ${pkgs.neovim}/bin/nvim %F";
      categories = [ "TerminalEmulator" ];
      terminal = false;
      mimeType = [ "text/plain" ];
    };
    desktopEntries."firefox" = ifLinux {
      name = "Firefox";
      comment = "Web Browser Firefox";
      icon = "firefox";
      exec = "firefox";
      categories = [ "WebBrowser" ];
      terminal = false;
      mimeType = [ "application/pdf" ];
    };
    desktopEntries."bottles" = ifLinux {
      name = "Bottles";
      comment = "Bottles";
      icon = "usebottles.bottles.com";
      exec = "flatpak run com.usebottles.bottles -b Gaming --run";
      categories = [ "Application" ];
      terminal = false;
      mimeType = [ "application/vnd.microsoft.portable-executable" ];
    };
  };


  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    withRuby = true;
    withNodeJs = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      git
      nil
      lua-language-server
      gcc
      gnumake
      unzip
      wget
      curl
      tree-sitter
      ripgrep-all
      fd
      fzf
      lazygit
    ] ++ deps;
  };
}
