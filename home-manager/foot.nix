{ pkgs, ... }:{
  home = {
    packages = with pkgs; [
        foot
        zellij
        jetbrains-mono
        zoxide
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
}
