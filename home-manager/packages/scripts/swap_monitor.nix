
{ pkgs, ...}: 
let swap_monitors = pkgs.writeShellScriptBin "swap_monitors" 

''
import subprocess
import json

result = subprocess.run(['hyprctl', 'monitors', '-j'], capture_output=True, text=True)
parsed_json = list(filter( lambda i: i["focused"]==False , json.loads(result.stdout)))  # noqa: E712

subprocess.run(['hyprctl', "dispatch", "focusmonitor", str(parsed_json[0]["id"])])
'';
in {
  home.packages = [swap_monitors];
}

