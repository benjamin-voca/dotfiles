{inputs,pkgs, config, ...}: {

  home.packages = with pkgs; [
  zellij
  ];
  programs.zellij = {
    enable = true;
    #enableNushellIntegration = true;
    settings = {
      theme = "base16";
      default_shell = "nu";
    };
  };
}
