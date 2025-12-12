# NixOS 快速开始指南

## 🚀 快速安装（5 分钟版本）

### 1. 安装基础 NixOS

1. 下载 NixOS ISO：https://nixos.org/download.html
2. 创建启动 USB，从 USB 启动
3. 按照安装向导完成基础安装

### 2. 应用此配置

```bash
# 以 root 登录后，创建用户
useradd -m -G wheel student
passwd student

# 允许 wheel 组使用 sudo
nano /etc/nixos/configuration.nix
# 取消注释这一行：
# security.sudo.wheelNeedsPassword = false;

# 切换到用户
su - student

# 获取配置文件
cd ~
git clone https://github.com/apple-pear-greap/MyRep.git
cp -r MyRep/nixos-config ~/nixos-config
cd ~/nixos-config

# 复制硬件配置
sudo cp /etc/nixos/hardware-configuration.nix .

# 修改主机名
# 编辑 flake.nix，将 "your-hostname" 改为你喜欢的名字，例如 "nixos-laptop"

# 编辑 home.nix
# 修改 Git 配置中的用户名和邮箱

# 应用配置
sudo nixos-rebuild switch --flake .#nixos-laptop

# 重启
sudo reboot
```

### 3. 首次使用

```bash
# 登录后，配置输入法
# 系统设置 -> 区域和语言 -> 输入源 -> 添加中文

# 配置终端主题
p10k configure

# 测试环境
python3 -c "import numpy; print('Python 环境正常')"
gcc --version
```

## ⚙️ 快速自定义

### 添加软件

编辑 `~/nixos-config/configuration.nix`：

```nix
environment.systemPackages = with pkgs; [
  # 添加你需要的软件
  spotify
  vlc
  # ...
];
```

然后运行：
```bash
sudo nixos-rebuild switch --flake ~/nixos-config#nixos-laptop
```

### 修改电源策略

编辑 `~/nixos-config/configuration.nix`，找到 `services.tlp.settings`，调整参数。

### 切换到轻量桌面

如果 GNOME 太重，可以改用 XFCE：

编辑 `~/nixos-config/configuration.nix`：
```nix
services.xserver = {
  # 注释掉 GNOME
  # displayManager.gdm.enable = true;
  # desktopManager.gnome.enable = true;
  
  # 启用 XFCE
  displayManager.lightdm.enable = true;
  desktopManager.xfce.enable = true;
};
```

## 📌 常用命令

```bash
# 更新系统
cd ~/nixos-config
sudo nix flake update
sudo nixos-rebuild switch --flake .#nixos-laptop

# 搜索软件
nix search nixpkgs 软件名

# 清理旧配置
sudo nix-collect-garbage -d

# 查看系统信息
nixos-version
```

## 💡 提示

1. **配置文件位置**：`~/nixos-config/`
2. **重建系统**：每次修改配置后运行 `sudo nixos-rebuild switch --flake ~/nixos-config#nixos-laptop`
3. **备份配置**：定期 `git commit` 你的配置更改
4. **回滚**：如果新配置有问题，重启时在 GRUB 菜单选择旧版本

## 🔗 有用链接

- 完整文档：查看 `README.md`
- NixOS 官方：https://nixos.org/
- 软件包搜索：https://search.nixos.org/

## ❓ 问题？

查看 `README.md` 中的"故障排除"章节。
