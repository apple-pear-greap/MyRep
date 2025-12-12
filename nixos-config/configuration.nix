# NixOS 系统配置 - 为数学与统计学专业学生优化
# 注重效率和续航

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ===== 启动和内核 =====
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # 最新内核以获得更好的硬件支持和性能
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 内核参数优化续航
  boot.kernelParams = [
    "quiet"
    "splash"
    "pci=nomsi"  # 某些设备可能需要此参数以节省电量
  ];

  # ===== 网络配置 =====
  networking = {
    hostName = "nixos-student";
    networkmanager.enable = true;
    # 启用防火墙
    firewall.enable = true;
  };

  # ===== 时区和本地化 =====
  time.timeZone = "Asia/Shanghai";
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-chinese-addons
        fcitx5-gtk
      ];
    };
  };

  # 控制台字体
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # ===== 用户配置 =====
  users.users.student = {
    isNormalUser = true;
    description = "数学与统计学学生";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # ===== 电源管理和续航优化 =====
  # TLP - Linux 高级电源管理
  services.tlp = {
    enable = true;
    settings = {
      # CPU 节能设置
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      # CPU 能源性能偏好
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      # CPU Boost
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      
      # 平台配置文件
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      
      # 磁盘设备
      DISK_DEVICES = "nvme0n1 sda";
      DISK_IOSCHED = "mq-deadline";
      
      # 运行时电源管理
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      
      # USB 自动挂起
      USB_AUTOSUSPEND = 1;
      
      # WiFi 电源管理
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      
      # 声卡电源管理
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
    };
  };

  # 自动 CPU 频率调节
  services.auto-cpufreq = {
    enable = false;  # TLP 和 auto-cpufreq 冲突，只启用其中一个
  };

  # 禁用不需要的服务以节省电量
  services.thermald.enable = true;  # Intel CPU 热管理

  # ===== 图形界面 =====
  services.xserver = {
    enable = true;
    
    # 桌面环境 - GNOME (高效且现代)
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    
    # 或者使用更轻量的 XFCE
    # desktopManager.xfce.enable = true;
    
    # 键盘布局
    layout = "us";
    
    # 触摸板设置
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
      };
    };
  };

  # GNOME 排除不需要的应用以节省资源
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany  # 网页浏览器
    geary     # 邮件客户端
  ];

  # ===== 声音 =====
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ===== 系统软件包 =====
  environment.systemPackages = with pkgs; [
    # === 基础工具 ===
    vim
    neovim
    wget
    curl
    git
    htop
    btop
    tree
    unzip
    zip
    p7zip
    
    # === C 语言开发 ===
    gcc
    clang
    gdb
    lldb
    cmake
    gnumake
    pkg-config
    
    # === Python 开发 ===
    (python311.withPackages (ps: with ps; [
      # 数据科学和数学
      numpy
      scipy
      pandas
      matplotlib
      seaborn
      sympy
      
      # 统计学
      statsmodels
      scikit-learn
      
      # Jupyter 笔记本
      jupyter
      ipython
      notebook
      
      # 实用工具
      pip
      virtualenv
      pytest
    ]))
    
    # === 数学和统计软件 ===
    # LaTeX 文档编写
    texlive.combined.scheme-full
    
    # 数学计算软件
    maxima
    octave
    # sagemath  # 较大，可选安装
    
    # R 语言和 RStudio
    R
    rstudio
    
    # === 开发工具和 IDE ===
    vscode
    # 或者更轻量的编辑器
    # vscodium
    # kate
    
    # === 浏览器 ===
    firefox
    
    # === 实用工具 ===
    gnome.gnome-tweaks
    gnome.dconf-editor
    
    # 终端
    kitty
    
    # 文件管理
    ranger
    
    # 版本控制 GUI
    gitg
    
    # 文档查看
    evince
    okular
    
    # 截图工具
    flameshot
    
    # 系统监控
    powertop
    
    # 字体
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-han-sans
    source-han-serif
    wqy_microhei
    wqy_zenhei
  ];

  # ===== 字体配置 =====
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Source Code Pro" "Noto Sans Mono CJK SC" ];
        sansSerif = [ "Noto Sans CJK SC" "Noto Sans" ];
        serif = [ "Noto Serif CJK SC" "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # ===== 程序配置 =====
  programs = {
    # ZSH shell
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    
    # Git
    git.enable = true;
    
    # GnuPG
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # ===== Nix 设置 =====
  nix = {
    settings = {
      # 启用 Flakes 和新命令
      experimental-features = [ "nix-command" "flakes" ];
      
      # 自动优化存储
      auto-optimise-store = true;
      
      # 构建时使用所有核心
      max-jobs = "auto";
    };
    
    # 垃圾回收
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # ===== 系统自动升级 =====
  system.autoUpgrade = {
    enable = false;  # 手动控制更新以避免意外
    allowReboot = false;
  };

  # NixOS 版本（不要修改）
  system.stateVersion = "23.11";
}
