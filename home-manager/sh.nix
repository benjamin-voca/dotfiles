{ pkgs, config, ... }:
let
  nx-switch = pkgs.writeShellScriptBin "nx-switch" ''
    ${../symlink.nu} -r
    ${if pkgs.stdenv.isDarwin
      then "darwin-rebuild switch --flake . --impure"
      else "sudo nixos-rebuild switch --flake . --impure"
    }
    ${../symlink.nu} -a
  '';
  vault = pkgs.writeShellScriptBin "vault" ''
    cd ~/Vault
    git add .
    gc -m 'sync $(date '+%Y-%m-%d %H:%M')'
    git push
  '';
  shellAliases = {
    "db" = "distrobox";
    "eza" = "eza -l --sort type --no-permissions --no-user --no-time --header --icons --no-filesize --group-directories-first";
    "tree" = "eza --tree";
    "ll" = "eza";
    "l" = "eza";
    "nv" = "nvim";
    ":q" = "exit";
    "q" = "exit";
    "gs" = "git status";
    "gb" = "git branch";
    "gch" = "git checkout";
    "gc" = "git commit";
    "ga" = "git add";
    "gr" = "git reset --soft HEAD~1";
    "f" = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
    "del" = "gio trash";
    "battHealth" = "upower -i /org/freedesktop/UPower/devices/battery_BAT1";# | rg 'capacity'";
    "yt" = "yt-dlp -N 5 --add-metadata -ic -f 'best[height<=1440]'+bestaudio -o '~/yt/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'";
    "yts" = "yt-dlp -N 5 --add-metadata -ic -f bestvideo+bestaudio -o '~/yt/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'";
    "yta" = "yt-dlp -N 5 --embed-thumbnail -f bestaudio -x --audio-format mp3 --audio-quality 320k --add-metadata -ic -o ~/Music/'%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'";
    "td" = "~/.local/share/go/bin/torrent download";
    "torrent" = "~/.local/share/go/bin/torrent ";
    "nix-shell" = "nix-shell --run nu";
  };
in
{
  home.packages = [nx-switch vault];

  programs = {
    thefuck.enable = true;
    zoxide.enableNushellIntegration = true;

    zsh = {
      inherit shellAliases;
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        SHELL=${pkgs.zsh}/bin/zsh
        zstyle ':completion:*' menu select
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      '';
    };

    bash = {
      inherit shellAliases;
      enable = true;
      initExtra = "SHELL=${pkgs.bash}";
    };

    nushell = {
      inherit shellAliases;
      enable = true;
      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = "\"  \"";
        PROMPT_INDICATOR_VI_NORMAL = "\"∙ \"";
        PROMPT_COMMAND = ''""'';
        PROMPT_COMMAND_RIGHT = ''""'';
        NIXPKGS_ALLOW_UNFREE = "1";
        NIXPKGS_ALLOW_INSECURE = "1";
        SHELL = ''"${pkgs.nushell}/bin/nu"'';
        #NIX_BUILD_SHELL = ''"${pkgs.nushell}/bin/nu"'';
        EDITOR = config.home.sessionVariables.EDITOR;
        VISUAL = config.home.sessionVariables.VISUAL;
      };
      extraConfig = let
        conf = builtins.toJSON {
          show_banner = false;
          edit_mode = "vi";
          shell_integration = true;

          ls.clickable_links = true;
          rm.always_trash = true;

          table = {
            mode = "compact"; # compact thin rounded
            index_mode = "always"; # alway never auto
            header_on_separator = false;
          };

          cursor_shape = {
            vi_insert = "line";
            vi_normal = "block";
          };

          menus = [({
            name =  "completion_menu";
            only_buffer_difference = false;
            marker = "? ";
            type = {
              layout = "columnar"; # list, description
              columns = 4;
              col_padding = 2;
            };
            style = {
              text = "magenta";
              selected_text = "blue_reverse";
              description_text = "yellow";
            };
          })];
        };
        completion = name: ''
          source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
        '';
        completions = names: builtins.foldl'
          (prev: str: "${prev}\n${str}") ""
          (map (name: completion name) names);
      in ''
        $env.config = ${conf};
        ${completions ["cargo" "git" "nix" "npm"]}
        source ~/.config/.zoxide.nu;
      '';
    };
  };
}
