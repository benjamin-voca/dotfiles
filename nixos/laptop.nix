#{ config, ... }: {
#  # asusctl
#  services.asusd = {
#    enable = true;
#    enableUserService = true;
#  };
#
#  # nvidia
#  hardware.opengl = {
#    enable = true;
#    driSupport = true;
#    driSupport32Bit = true;
#  };
#
#  services.xserver.videoDrivers = ["nvidia"];
#
#  hardware.nvidia = {
#    prime = {
#      offload.enable = true;
#      offload.enableOffloadCmd = true;
#      nvidiaBusId = "PCI:1:0:0";
#      amdgpuBusId = "PCI:6:0:0";
#    };
#
#    modesetting.enable = true;
#
#    powerManagement = {
#      enable = true;
#      finegrained = true;
#    };
#
#    open = true;
#    nvidiaSettings = false; # gui app
#    package = config.boot.kernelPackages.nvidiaPackages.latest;
#  };
#

{ config, ... }: {
  services.auto-cpufreq={
    enable = true;
  settings = {
  battery = {
     governor = "powersave";
     turbo = "auto";
  };
  charger = {
     governor = "performance";
     turbo = "auto";
  };
  };
};

}
