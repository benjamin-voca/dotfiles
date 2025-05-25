{pkgs, ...}: let
  gamer-mode = pkgs.writeScriptBin "gamer-mode" ''
    HYPRGAMEMODE=$(${pkgs.hyprland}/bin/hyprctl getoption animations:enabled | ${pkgs.gawk}/bin/awk 'NR==1{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
        echo "turning animations off"
        ${pkgs.hyprland}/bin/hyprctl --batch "\
            keyword animations:enabled 0;\
            # keyword decoration:drop_shadow 0;\
            # keyword decoration:blur:enabled 0;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1;\
            keyword decoration:rounding 0"
        # ${pkgs.procps}/bin/pkill ags
        # ${pkgs.procps}/bin/pkill swww
        exit
    fi
    ${pkgs.hyprland}/bin/hyprctl reload 
    # ${pkgs.ags}/bin/ags -b hypr
    # ${pkgs.swww}/bin/swww-daemon
  '';
in {
  home.packages = [gamer-mode];
}
