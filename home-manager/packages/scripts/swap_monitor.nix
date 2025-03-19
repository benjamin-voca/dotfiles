
{ pkgs, ...}: 
let swap_monitors = pkgs.writers.writePython3Bin "swap_monitors" {} ''
import subprocess
import json

result = subprocess.run(['hyprctl', 'monitors', '-j'], capture_output=True, text=True)
parsed_json = list(filter( lambda i: i["focused"]==False , json.loads(result.stdout)))

subprocess.run(['hyprctl', 'dispatch', 'focusmonitor', str(parsed_json[0]['id'])])
'';
in {
  home.packages = [swap_monitors];
}

