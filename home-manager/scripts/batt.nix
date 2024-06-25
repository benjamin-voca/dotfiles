{ pkgs, ...}:{
  home.packages = with pkgs; [ pkgs.writeShellScriptBin "batteryNotify" builtins.readFile "./batteryNotify.sh" ];
}
