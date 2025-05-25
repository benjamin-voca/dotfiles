{ ... }: {
  programs.direnv = {
    enable = true;
    #enableFishIntegration = true;
    enableNushellIntegration = false;
    nix-direnv.enable = true;  
  };
}
