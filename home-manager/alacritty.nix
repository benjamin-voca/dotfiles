{pkgs, ... }:
{
programs.alacritty = {
		enable = true;
		settings = {
      shell = {
        program = "${pkgs.nushell}/bin/nu";
        args = "${pkgs.zellij}/bin/zellij";
      };
			env.TERM = "xterm-256color";
			window.padding = {
				x = 10;
				y=10;
			};
			window.decorations = "none";
			window.opacity = 0.7;
			scrolling.history = 1000;
			font = {
				normal = {
					family = "JetBrains Mono Nerd Font";
					style = "Regular";
				};
				bold = {
					family = "JetBrains Mono Nerd Font";
					style = "Bold";
				};
				italic = {
					family = "JetBrains Mono Nerd Font";
					style = "Italic";
				};
				size = 14;
			};
		};
	};
}
