{inputs,pkgs, config, ...}: {
  programs.nushell.enable = true;

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable=true;
  };
}
