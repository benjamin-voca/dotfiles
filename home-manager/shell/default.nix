{ pkgs,  ... }:
let
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
    "yt" = "yt-dlp -N 8 --add-metadata -ic -f 'best[height<=1440]'+bestaudio -o '~/yt/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'";
    "yts" = "yt-dlp -N 8 --add-metadata -ic -f bestvideo+bestaudio -o '~/yt/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'";
    "yta" = "yt-dlp -N 8 --embed-thumbnail -f bestaudio -x --audio-quality 0 --add-metadata -ic -o ~/Music/'%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'";
    "td" = "~/.local/share/go/bin/torrent download";
    "torrent" = "~/.local/share/go/bin/torrent ";
    #"nix-shell" = "nom-shell --run fish";
    "nix-build" = "nom-build";
    "nix" = "nom";
    "ns" = "nom-shell --run fish -p ";
    "nhs" = "nh search";
    # "in" = "nom-shell -p (echo $history[1]) --run fish";
    "o" = "ouch";
    "od" = "ouch d";
    "oc" = "ouch c";

    "ol" = "ouch l";
    "xo" = "xdg-open";
    "d" = "devenv";
    # "nxe" = "hx $FLAKE";
    "lsPkgs" = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq";
    "orari" = "/home/benjamin/scripts/tabela.py";
    "dwSite" = "wget2 --max-threads=16 --mirror --convert-links --adjust-extension --page-requisites --no-parent --domains= ";
    # "hxs" = "nix run ~/repos/rrrr/new/helix";
    "rg" = "rga";
    "j" = "just";
    "lg" = "lazygit";
    "envEcho" = "echo 'use flake' > .envrc; direnv allow";
  };
  in
{
  #./nvim.nix 
  imports = [ ./direnv.nix ./distrobox.nix ./git.nix ./helix.nix ./yazi.nix ./starship];
  #btop custom theme
  home.file.".config/btop/themes/gruber-darker.theme".source = ./gruber-darker.theme;

  programs = {
    zoxide = {
      enable = true;
    };
    atuin = {
      enable = true;
    };

    fish = {
      inherit shellAliases;
      enable = true;
      #put source statements here to avoid confusion when launching sub-shell
      shellInit = ''
        source ${../packages/scripts/source.fish}
      '';
      interactiveShellInit = ''
        any-nix-shell fish --info-right | source
        nh completions --shell fish | source
        rg --generate=complete-fish | source
        set fish_greeting
        nb todo

        fish_vi_key_bindings

        function burnSubs
            set input_video $argv[1]
            set subtitle_file $argv[2]
            set output_video output_video.mp4

            ffmpeg -vaapi_device /dev/dri/renderD128 -i $input_video -vf "subtitles=$subtitle_file:force_style=auto,format=nv18,hwupload" -c:v h264_vaapi -b:v 2M -c:a copy $output_video
        end

        function ramdisk
            set -l size $argv[1]
    
            set mount_point /mnt/ramdisk
            sudo mkdir -p $mount_point
            sudo mount -t tmpfs -o size=$size tmpfs $mount_point
            cd $mount_point

            # Delete the mount directory upon exiting
            trap 'sudo umount $mount_point; sudo rmdir $mount_point' EXIT
        end


        function killOnLocalPort
            set port $argv[1]
            sudo kill -9 (nix run nixpkgs#lsof -- -t -i:$port -sTCP:LISTEN)
        end

        function battHealth
            upower -i /org/freedesktop/UPower/devices/battery_BAT1 | rg "%"
        end

        function tmprust
            cd /tmp
            cargo init temporary
            cd temporary
            neovide &
            cargo-watch -x build
        end


        function ff
            bat (find . | fzf)
        end



        bind \ec "echo -n \"  &| wl-copy\"" # Replace ^c with \ca or \C-c


        alias libv 'systemctl start libvirtd; virt-manager; exit'
        alias man 'batman'
        alias adv '/home/benjamin/scripts/aocbash.sh'
        alias md 'mkdir -p'
        alias mdh 'cp -r template '
        #alias mpc 'mpc -h 0.0.0.0 -p 6601'
        alias nix-shell 'nix-shell --run fish'
        alias resPipe 'systemctl --user daemon-reload'
        alias td 'torrent download'
        #alias tsh 'sudo -E timeshift-launcher'
        #alias tshc 'sudo timeshift --create'
        alias si 'sudo intel_gpu_top'
        alias grep 'rga'
        alias ct 'cargo-tauri'
        alias sssd 'sudo systemctl start docker'
        alias ys 'yarn start'
        alias yadd 'yarn add'

        # function yt
        #     yt-dlp -N 5 --add-metadata -ic -f 'best[height<=1440]'+bestaudio -o '~/yt/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $argv
        # end

        # function yta
        #     yt-dlp -N 5 --embed-thumbnail -f bestaudio -x --audio-format mp3 --audio-quality 320k --add-metadata -ic -o ~/Music/'%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $argv
        # end

        # function yts
        #     yt-dlp -N 5 --add-metadata -ic -f bestvideo+bestaudio -o '~/yt/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $argv
        # end

        '';
    };
    zsh = {
      inherit shellAliases;
      enable = false;
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
        PROMPT_INDICATOR_VI_INSERT = "";
        PROMPT_INDICATOR_VI_NORMAL = "";
        # PROMPT_COMMAND = ''""'';
        # PROMPT_COMMAND_RIGHT = ''""'';
        # NIXPKGS_ALLOW_UNFREE = "1";
        # NIXPKGS_ALLOW_INSECURE = "1";
        # SHELL = ''"${pkgs.nushell}/bin/nu"'';
        #NIX_BUILD_SHELL = ''"${pkgs.nushell}/bin/nu"'';
        #EDITOR = config.home.sessionVariables.EDITOR;
        #VISUAL = config.home.sessionVariables.VISUAL;
        # CARGO_TARGET_DIR="~/.cargo/cargo-target/";
        # PAGER = "bat";
      };
      /*
      environmentVariables = {
        # PROMPT_COMMAND = "{ || create_left_prompt }";
        PROMPT_COMMAND_RIGHT = ''""'';
        PROMPT_INDICATOR = ''""'';
        PROMPT_INDICATOR_VI_INSERT = ''""'';
        PROMPT_INDICATOR_VI_NORMAL = ''""'';
        PROMPT_MULTILINE_INDICATOR = ''""'';
      };*/
      extraConfig = let
        conf = builtins.toJSON {
          show_banner = false;
          edit_mode = "vi";

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
        direnvHook = ''
          if ($env.PWD | path join ".envrc" | path exists) {
            direnv export json | from json | load-env
          }
        '';
        completion = name: ''
          source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
        '';
        completions = names: builtins.foldl'
          (prev: str: "${prev}\n${str}") ""
          (map (name: completion name) names);
      in ''
        def create_left_prompt [] {
            starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
        }
        $env.config = ${conf};
        ${completions ["cargo" "git" "nix" "npm"]}
        ${direnvHook}
      '';
    };
  };
}
