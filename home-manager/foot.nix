{ pkgs, ... }:{
  home = {
    packages = with pkgs; [
      foot
        zellij
        jetbrains-mono
# xterm
    ];
    sessionVariables.TERMINAL = "foot";
  };
  programs.foot = {
    enable = true;
    server.enable = true;

    settings = {
      main ={
        font = "JetBrainsMono NF:size=12";
      };
      colors = {

        alpha=1.0;
        background="171702";
        foreground="b2b5b3";
        flash="ff0000";
        flash-alpha=1.0;

        regular0="373839";
        regular1="e55f86";
        regular2="00D787";
        regular3="EBFF71";
        regular4="51a4e7";
        regular5="9077e7";
        regular6="51e6e6";
        regular7="e7e7e7";

        bright0="313234";
        bright1="d15577";
        bright2="43c383";
        bright3="d8e77b";
        bright4="4886c8";
        bright5="8861dd";
        bright6="43c3c3";
        bright7="b2b5b3";
      };
    };
  };

  home.file.".local/share/blackbox/schemes/charmful.json".text = builtins.toJSON{
    name = "Charmful";
    foreground-color = "#b2b5b3";
    background-color = "#171702";
    use-theme-colors = true;
    use-highlight-color = true;
    highlight-foreground-color = "#ffffff";
    highlight-background-color = "#313234";
    use-cursor-color = true;
    cursor-foreground-color = "#ffffff";
    cursor-background-color = "#e7e7e7";
    use-badge-color = true;
    badge-color = "#ff0000";
    palette = [
      "#373839"
        "#e55f86"
        "#00D787"
        "#EBFF71"
        "#51a4e7"
        "#9077e7"
        "#51e6e6"
        "#e7e7e7"
        "#313234"
        "#d15577"
        "#43c383"
        "#d8e77b"
        "#4886c8"
        "#8861dd"
        "#43c3c3"
        "#b2b5b3"
    ];
  };

  dconf.settings."com/raggesilver/BlackBox" = {
    command-as-login-shell = true;
    custom-shell-command = "${pkgs.zellij}/bin/zellij";
    use-custom-command = true;
    font = "CaskaydiaCove Nerd Font 12";
    fill-tabs = true;
    show-headerbar = false;
    pretty = true;
    theme-light = "Adwaita";
    theme-dark = "Charmful";
  };
              }
