# 硬件配置文件模板
# 请运行 'nixos-generate-config' 来生成适合你硬件的配置
# 或者在安装 NixOS 时自动生成

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ===== CPU 微码 =====
  # 根据你的 CPU 选择一个
  hardware.cpu.intel.updateMicrocode = true;  # Intel CPU
  # hardware.cpu.amd.updateMicrocode = true;  # AMD CPU

  # ===== 文件系统 =====
  # 这部分需要根据你的实际分区情况修改
  # 运行 'nixos-generate-config' 会自动生成正确的配置
  
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/YOUR-BOOT-UUID";
    fsType = "vfat";
  };

  # 如果有 swap 分区
  swapDevices = [
    { device = "/dev/disk/by-uuid/YOUR-SWAP-UUID"; }
  ];

  # ===== 网络硬件 =====
  # 根据需要启用
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  # ===== 显卡驱动 =====
  # Intel 集成显卡
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # NVIDIA 显卡 (如果有独立显卡)
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   open = false;
  #   nvidiaSettings = true;
  # };

  # ===== 其他硬件设置 =====
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
