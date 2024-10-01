{ pkgs , ... }: {

  home.file.".config/zellij/layouts/default.kdl".source = ./default.kdl;
  home.file.".config/zellij/config.kdl".source = ./config.kdl;
  home.packages = with pkgs; [
    zellij
  ];
  programs.zellij = {
    enable = true;
  };
}
