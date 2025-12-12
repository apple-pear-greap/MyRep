# 配置示例和调整

本文档提供一些常见场景的配置调整示例。

## 场景 1：超长续航模式

如果你需要最大化电池续航时间，可以进行以下调整：

### 修改 `configuration.nix`

```nix
# 更激进的电源管理
services.tlp.settings = {
  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  CPU_MIN_PERF_ON_BAT = 0;
  CPU_MAX_PERF_ON_BAT = 30;  # 限制最大性能为 30%
  CPU_BOOST_ON_BAT = 0;
  
  # 更积极的设备挂起
  RUNTIME_PM_ON_BAT = "auto";
  USB_AUTOSUSPEND = 1;
  USB_AUTOSUSPEND_DISABLE_ON_SHUTDOWN = 0;
  
  # 降低磁盘 I/O
  DISK_IDLE_SECS_ON_BAT = 2;
  MAX_LOST_WORK_SECS_ON_BAT = 15;
};

# 使用更轻量的桌面
services.xserver.desktopManager.xfce.enable = true;
```

## 场景 2：最大性能模式

如果你在做重度计算（如运行大型模拟、机器学习训练），需要最大性能：

### 修改 `configuration.nix`

```nix
# 禁用 TLP，使用性能调速器
services.tlp.enable = false;

# 始终使用性能模式
powerManagement.cpuFreqGovernor = "performance";

# 确保所有核心可用
nix.settings.max-jobs = "auto";
nix.settings.cores = 0;  # 使用所有核心
```

## 场景 3：添加深度学习环境

如果你需要进行机器学习/深度学习：

### 修改 `configuration.nix`

```nix
environment.systemPackages = with pkgs; [
  # 现有软件...
  
  # 深度学习框架
  python311Packages.tensorflow
  python311Packages.torch
  python311Packages.torchvision
  
  # GPU 加速（如果有 NVIDIA 显卡）
  cudatoolkit
  cudnn
  
  # 额外工具
  python311Packages.keras
  python311Packages.opencv4
];

# NVIDIA GPU 支持
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;  # 性能优先
  open = false;
  nvidiaSettings = true;
};
```

## 场景 4：最小安装（轻量系统）

如果你想要最小化的系统占用：

### 修改 `configuration.nix`

```nix
# 使用轻量窗口管理器代替完整桌面
services.xserver = {
  enable = true;
  displayManager.lightdm.enable = true;
  windowManager.i3.enable = true;  # 或 awesome, xmonad
};

# 减少预装软件
environment.systemPackages = with pkgs; [
  # 只保留必需品
  vim
  git
  firefox
  
  # C/Python 开发
  gcc
  python311
  
  # 必要工具
  wget
  curl
];

# 禁用不需要的服务
services.gnome.gnome-keyring.enable = false;
```

## 场景 5：双语环境（中英文）

更好的中英文混合体验：

### 修改 `configuration.nix`

```nix
i18n = {
  defaultLocale = "en_US.UTF-8";
  supportedLocales = [
    "zh_CN.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
  extraLocaleSettings = {
    LC_TIME = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
  };
};

# 更多中文字体
environment.systemPackages = with pkgs; [
  # ... 现有软件
  
  # 额外字体
  noto-fonts-cjk-sans
  noto-fonts-cjk-serif
  adobe-source-han-sans
  adobe-source-han-serif
  font-awesome
];
```

## 场景 6：添加常用科研工具

### 修改 `configuration.nix`

```nix
environment.systemPackages = with pkgs; [
  # ... 现有软件
  
  # 文献管理
  zotero
  
  # 绘图工具
  inkscape
  gimp
  
  # 数据可视化
  gnuplot
  graphviz
  
  # 远程连接
  remmina
  
  # 云存储同步
  # rclone
  # syncthing
];
```

## 场景 7：服务器/远程开发

如果你需要 SSH 远程访问：

### 修改 `configuration.nix`

```nix
# 启用 SSH
services.openssh = {
  enable = true;
  settings = {
    PasswordAuthentication = true;
    PermitRootLogin = "no";
  };
};

# 防火墙允许 SSH
networking.firewall.allowedTCPPorts = [ 22 ];

# 安装远程开发工具
environment.systemPackages = with pkgs; [
  # ... 现有软件
  
  openssh
  mosh  # 移动 shell，不稳定网络下更好
  tmux  # 终端复用器
];
```

## 性能基准测试

安装性能测试工具：

```nix
environment.systemPackages = with pkgs; [
  # ... 现有软件
  
  # 性能测试
  sysbench
  stress
  s-tui
  
  # 监控
  iotop
  nethogs
];
```

使用方法：
```bash
# CPU 压力测试
stress --cpu 8 --timeout 60s

# 查看 CPU 温度和频率
s-tui

# 系统基准测试
sysbench cpu run
sysbench memory run
```

## 自动备份配置

使用 Git 自动跟踪配置变化：

### 添加到 `configuration.nix`

```nix
# 自动备份脚本
environment.systemPackages = [ pkgs.git ];

# 可以创建定时任务备份
systemd.user.services.backup-nixos-config = {
  description = "Backup NixOS configuration";
  serviceConfig = {
    Type = "oneshot";
    ExecStart = ''
      ${pkgs.bash}/bin/bash -c '
        cd /home/student/nixos-config
        ${pkgs.git}/bin/git add -A
        ${pkgs.git}/bin/git commit -m "Auto backup $(date +%Y-%m-%d)"
        ${pkgs.git}/bin/git push
      '
    '';
  };
};

systemd.user.timers.backup-nixos-config = {
  description = "Backup NixOS configuration timer";
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnCalendar = "daily";
    Persistent = true;
  };
};
```

## 注意事项

1. **测试配置**：使用 `sudo nixos-rebuild test` 先测试，确认无误后再 `switch`
2. **备份**：修改重要配置前，先备份当前工作配置
3. **渐进式修改**：一次只改一个方面，便于排查问题
4. **检查日志**：出问题时查看 `journalctl -xe`

## 获取更多灵感

- NixOS 配置示例：https://github.com/topics/nixos-configuration
- NixOS Wiki：https://nixos.wiki/
- Awesome NixOS：https://github.com/nix-community/awesome-nix
