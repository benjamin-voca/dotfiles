{ pkgs, ... }: {
  home.packages = with pkgs; [
    bat
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;

    keymap = {
      manager = {
        prepend_keymap = [
          {
            on = "T";
            run = "plugin --sync max-preview";
            desc = "Maximize or restore preview";
          }
        ];
      };
    };

    settings = {
      manager = {
        show_hidden = true;
        sort_dir_first = true;
        sort_by = "natural";
      };
    };
  };
}
