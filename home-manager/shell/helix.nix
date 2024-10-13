{ pkgs, inputs,  ... }: {
  programs.helix = {
    enable = true;
    package = inputs.hxs.packages.x86_64-linux.default;

    extraPackages = with pkgs; with nodePackages; [
      vscode-langservers-extracted
      gopls
      gotools
      typescript
      typescript-language-server
      marksman
      nil
      nixpkgs-fmt
      clang-tools
      lua-language-server
      rust-analyzer
      bash-language-server
      lldb
    ];

    languages = {
      language = [
        {
          name = "go";
          scope = "source.go";
          auto-format = true;
          formatter = {
            command = "goimports";
          };
        }
        {
          name = "typescript";
          scope = "source.ts";
          indent = {
            tab-width = 4;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "javascript";
          scope = "source.js";
          indent = {
            tab-width = 4;
            unit = " ";
          };
          auto-format = true;
        }
        {
          name = "nix";
          scope = "source.nix";
          formatter = {
            command = "nixpkgs-fmt";
          };
        }
        {
          name = "scheme";
          scope = "source.scm"; # Assuming Steel uses Scheme scope
          file-types = ["scm"]; # Assuming Steel uses ".scm" extension
          auto-format = true;
          formatter = {
            command = "raco";
            args = [ "fmt" "-i" ];
          };
          language-servers = [ "steel-language-server" ];
        }
      ];
      language-server = {
        steel-language-server = {
          command = "steel-language-server";
          args = [];
        };
      };
    };

    settings = {
      keys = {
        normal = {
          A-s = ":w";
          C-q = ":bclose";
          A-j = "goto_next_buffer";
          A-k = "goto_previous_buffer";
          A-d = [ "extend_to_line_bounds" "yank" "paste_after" ];
        };
      };

      theme = "gruber-darker";

      editor = {
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
          display-signature-help-docs = true;
        };
        line-number = "relative";
        completion-trigger-len = 1;
        bufferline = "multiple";
        color-modes = true;
        statusline = {
          left = [
            "mode"
            "spacer"
            "diagnostics"
            "version-control"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
            "spinner"
          ];
          right = [
            "file-encoding"
            "file-type"
            "selections"
            "position"
          ];
        };
        cursor-shape = {
          insert = "bar";
        };
        whitespace.render = {
          tab = "all";
        };
        indent-guides = {
          render = true;
          character = "┊";
        };
      };
    };
  };
}
