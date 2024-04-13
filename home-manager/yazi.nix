
{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    zoxide
  ];

  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.zoxide.enableNushellIntegration = true;

}
