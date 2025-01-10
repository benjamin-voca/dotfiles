{ pkgs, inputs, ... }:
let
  # Define a wrapped version of Helix with the necessary language servers and tools.
  hxs = pkgs.runCommand "hxs"
    {
      buildInputs = with pkgs; [
        inputs.hxs.packages.x86_64-linux.default # Original `hxs` package
        # vscode-langservers-extracted
        superhtml
        gopls
        gotools
        typescript
        typescript-language-server
        marksman
        markdown-oxide
        nil
        nixpkgs-fmt
        clang-tools
        lua-language-server
        rust-analyzer
        bash-language-server
        lldb
        # souffle-lsp  # Add souffle-lsp for Datalog support
      ];
    } ''
    mkdir -p $out/bin
    ln -s ${inputs.hxs.packages.x86_64-linux.default}/bin/hx $out/bin/hxs
  '';

  sharedHelixConfig = {
    enable = true;
    # package = inputs.hxs.packages.x86_64-linux.default;
    extraPackages = with pkgs; with nodePackages; [
      # vscode-langservers-extracted
      superhtml
      gopls
      gotools
      typescript
      typescript-language-server
      marksman
      markdown-oxide
      nil
      nixpkgs-fmt
      clang-tools
      lua-language-server
      rust-analyzer
      bash-language-server
      lldb
      # souffle-lsp  # Add souffle-lsp here as well
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
          scope = "source.scm";
          file-types = [ "scm" ];
          auto-format = true;
          formatter = {
            command = "raco";
            args = [ "fmt" "-i" ];
          };
          language-servers = [ "steel-language-server" ];
        }
        {
          name = "datalog"; # Add Datalog language configuration
          scope = "source.dl"; # Adjust the scope for Datalog files
          file-types = [ "dl" ];
          language-servers = [ "souffle-lsp" ]; # Specify the language server for Datalog
        }
        {

          name = "roc";
          scope = "source.roc";
          injection-regex = "roc";
          file-types = [ "roc" ];
          shebangs = [ "roc" ];
          roots = [ ];
          comment-token = "#";
          language-servers = [ "roc-ls" ];
          indent = { tab-width = 2; unit = "  "; };
          auto-format = true;
          formatter = { command = "roc"; args = [ "format" "--stdin" "--stdout" ]; };
        }
      ];
      grammar = {
        name = "roc";
        source = { git = "https://github.com/faldor20/tree-sitter-roc.git"; rev = "ef46edd0c03ea30a22f7e92bc68628fb7231dc8a"; };
      };

      language-server = {

        roc-ls = {
          command = "roc_language_server";
        };
        steel-language-server = {
          command = "steel-language-server";
          args = [ ];
        };
        souffle-lsp = {
          command = "souffle-lsp"; # Ensure the command for souffle-lsp is specified
          args = [ ];
        };


        rust-analyzer = {
          check.command = "clippy";
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

      theme = "base16_transparent";

      editor = {
        end-of-line-diagnostics = "hint";

        inline-diagnostics = {
          cursor-line = "error";
        };
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
        auto-pairs = { "(" = ")"; "{" = "}"; "[" = "]"; };
      };
    };
  };
in
{
  programs.helix = sharedHelixConfig;

  home.packages = [ hxs ];
}
