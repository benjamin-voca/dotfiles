{ pkgs, ... }:
let
  swap_monitors = pkgs.writers.writePython3Bin "swap_monitors"
    {
      flakeIgnore = [ "E501" "E127" ];
    } ''
    import subprocess
    import json

    r = subprocess.run(['hyprctl', 'monitors', '-j'], capture_output=True, text=True)
    p = list(filter(lambda i: not i["focused"], json.loads(r.stdout)))[0]
    subprocess.run(['hyprctl', 'dispatch', 'focusmonitor', str(p['id'])])
  '';
in
{
  home.packages = [ swap_monitors ];
}

