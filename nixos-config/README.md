# NixOS 配置 - 数学与统计学专业学习环境

这是一个专为数学与统计学专业学生设计的 NixOS 系统配置，强调效率和续航，同时包含 C 和 Python 开发环境。

## 📋 目录

- [系统特性](#系统特性)
- [安装指南](#安装指南)
- [使用说明](#使用说明)
- [软件清单](#软件清单)
- [性能优化](#性能优化)
- [常用命令](#常用命令)
- [故障排除](#故障排除)

## ✨ 系统特性

### 🔋 电源管理与续航优化
- **TLP 电源管理**：智能调节 CPU 频率和电源策略
- **自动节能**：电池模式下自动降低性能换取更长续航
- **USB 自动挂起**：减少不必要的电力消耗
- **WiFi 电源管理**：电池模式下优化无线网络功耗
- **智能背光控制**：根据使用场景自动调节屏幕亮度

### 📊 数学与统计工具
- **Python 科学计算栈**：NumPy, SciPy, Pandas, Matplotlib, Seaborn
- **Jupyter Notebook**：交互式数据分析环境
- **R 和 RStudio**：专业统计分析软件
- **LaTeX 完整套件**：编写数学文档和论文
- **符号计算**：SymPy (Python), Maxima
- **数值计算**：Octave (Matlab 替代品)
- **机器学习**：scikit-learn

### 💻 编程开发环境
- **C 语言开发**：GCC, Clang, GDB, LLDB, CMake, Make
- **Python 3.11**：最新稳定版 Python 及常用库
- **VSCode**：功能强大的集成开发环境
- **Neovim**：高效的命令行编辑器
- **Git**：版本控制系统

### 🎨 桌面环境
- **GNOME**：现代、高效的桌面环境
- **中文输入法**：Fcitx5 + Rime
- **中文字体**：思源黑体、思源宋体、文泉驿等

## 📦 安装指南

### 前置要求
1. 一台支持 UEFI 启动的电脑
2. NixOS 安装 ISO（建议 23.11 或更新版本）
3. 至少 20GB 硬盘空间
4. 建议 8GB 或以上内存

### 安装步骤

#### 1. 安装基础 NixOS 系统

从 NixOS 官网下载安装 ISO：https://nixos.org/download.html

启动安装镜像后，按照标准流程安装：

```bash
# 分区（示例，请根据实际情况调整）
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/sda -- set 1 boot on
sudo parted /dev/sda -- mkpart primary 512MiB 100%

# 格式化分区
sudo mkfs.fat -F 32 -n boot /dev/sda1
sudo mkfs.ext4 -L nixos /dev/sda2

# 挂载分区
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot

# 生成配置
sudo nixos-generate-config --root /mnt

# 进行基础安装
sudo nixos-install

# 设置 root 密码
# 重启
reboot
```

#### 2. 克隆并应用此配置

重启进入新系统后：

```bash
# 以 root 登录，创建普通用户
useradd -m -G wheel -s /bin/bash student
passwd student

# 切换到普通用户
su - student

# 克隆配置到 home 目录
cd ~
git clone https://github.com/apple-pear-greap/MyRep.git
cp -r MyRep/nixos-config ~/nixos-config
cd ~/nixos-config

# 复制硬件配置
sudo cp /etc/nixos/hardware-configuration.nix ~/nixos-config/

# 修改配置文件
# 1. 编辑 flake.nix，将 "your-hostname" 替换为实际主机名
# 2. 编辑 home.nix，修改 Git 用户名和邮箱
# 3. 检查 hardware-configuration.nix 是否正确

# 应用配置
sudo nixos-rebuild switch --flake .#your-hostname

# 重启使所有更改生效
sudo reboot
```

#### 3. 首次登录配置

重启后使用 `student` 用户登录：

```bash
# 配置 Fcitx5 输入法
# 在 GNOME 设置 -> 区域和语言 -> 输入源 中添加中文输入法

# 配置 Powerlevel10k 主题
p10k configure

# 测试 Python 环境
python3 --version
python3 -c "import numpy, scipy, pandas; print('科学计算库已就绪')"

# 测试 Jupyter
jupyter notebook

# 测试 C 编译器
gcc --version
echo 'int main() { return 0; }' > test.c
gcc test.c -o test
./test
```

## 🎯 使用说明

### 日常使用

#### 更新系统
```bash
# 更新 flake 输入
sudo nix flake update ~/nixos-config

# 重建系统
sudo nixos-rebuild switch --flake ~/nixos-config#your-hostname

# 或使用别名（已在 home.nix 中配置）
update   # 更新 flake
rebuild  # 重建系统
```

#### Python 开发
```bash
# 启动 Python
python3

# 启动 IPython
ipython

# 启动 Jupyter Notebook
jupyter notebook

# 创建虚拟环境（如需隔离环境）
python3 -m venv myenv
source myenv/bin/activate
```

#### C 语言开发
```bash
# 编译单个文件
gcc myprogram.c -o myprogram

# 使用调试信息编译
gcc -g myprogram.c -o myprogram

# 使用 GDB 调试
gdb ./myprogram

# 使用 CMake 项目
mkdir build && cd build
cmake ..
make
```

#### LaTeX 文档编写
```bash
# 编译 LaTeX 文档
pdflatex document.tex

# 使用 XeLaTeX（更好的中文支持）
xelatex document.tex
```

#### 使用 R 和 RStudio
```bash
# 命令行 R
R

# 启动 RStudio
rstudio
```

### VSCode 使用

系统已安装并配置 VSCode，包含以下扩展：
- Python 支持（语法高亮、调试、Pylance）
- C/C++ 支持
- Git 集成
- Vim 模式（可选）

启动方式：
```bash
code
# 或在应用菜单中找到 "Visual Studio Code"
```

### Neovim 使用

已配置基础的 Neovim 环境：
```bash
nvim filename

# 常用快捷键：
# Ctrl+n: 打开文件树
# <leader>w: 保存文件
# <leader>q: 退出
```

## 📚 软件清单

### 开发工具
- **编译器**：GCC, Clang
- **调试器**：GDB, LLDB
- **构建工具**：CMake, Make, pkg-config
- **编辑器/IDE**：VSCode, Neovim, Vim
- **版本控制**：Git, Gitg

### Python 生态
- **核心**：Python 3.11
- **科学计算**：NumPy, SciPy
- **数据分析**：Pandas
- **可视化**：Matplotlib, Seaborn
- **符号计算**：SymPy
- **统计**：Statsmodels
- **机器学习**：scikit-learn
- **交互环境**：Jupyter, IPython
- **质量工具**：Pylint, Black, MyPy

### 数学与统计
- **LaTeX**：TeXLive (完整版)
- **计算软件**：Maxima, Octave
- **统计**：R, RStudio
- **可选**：SageMath（如需要可取消注释安装）

### 系统工具
- **终端**：Kitty
- **Shell**：ZSH + Powerlevel10k
- **文件管理**：Ranger, Nautilus
- **系统监控**：htop, btop, powertop
- **压缩工具**：zip, unzip, p7zip
- **搜索工具**：ripgrep, fd, fzf

### 生产力工具
- **浏览器**：Firefox
- **笔记**：Obsidian
- **文档查看**：Evince, Okular
- **截图**：Flameshot

## ⚡ 性能优化

### 电源管理设置

系统通过 TLP 自动优化电源：

- **交流电模式**：性能优先，CPU 全速运行
- **电池模式**：续航优先，降低 CPU 频率，关闭 Turbo Boost

查看当前电源状态：
```bash
sudo tlp-stat
```

查看电池使用情况：
```bash
sudo powertop
```

### 手动性能调整

```bash
# 查看当前 CPU 频率
cat /proc/cpuinfo | grep MHz

# 查看当前调速策略
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# 临时切换到性能模式（需要 root）
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# 临时切换到省电模式
echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

### Nix Store 优化

```bash
# 手动清理旧的系统配置
sudo nix-collect-garbage -d

# 优化 Nix store
sudo nix-store --optimise

# 查看 Nix store 大小
du -sh /nix/store
```

## 🔧 常用命令

### NixOS 管理
```bash
# 重建系统（使用 flake）
sudo nixos-rebuild switch --flake ~/nixos-config#your-hostname

# 测试配置（不设为默认）
sudo nixos-rebuild test --flake ~/nixos-config#your-hostname

# 更新 flake 输入
sudo nix flake update ~/nixos-config

# 列出所有系统世代
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# 回滚到上一个配置
sudo nixos-rebuild switch --rollback

# 清理垃圾
sudo nix-collect-garbage -d
```

### 包管理
```bash
# 搜索软件包
nix search nixpkgs package-name

# 临时运行程序（不安装）
nix run nixpkgs#package-name

# 临时 shell 环境
nix shell nixpkgs#package1 nixpkgs#package2
```

### 开发环境
```bash
# 创建临时开发 shell
nix develop

# Python 虚拟环境
python3 -m venv env
source env/bin/activate
```

## 🐛 故障排除

### 常见问题

#### 1. 系统重建失败
```bash
# 检查配置语法
nix flake check ~/nixos-config

# 查看详细错误信息
sudo nixos-rebuild switch --flake ~/nixos-config#your-hostname --show-trace
```

#### 2. 中文输入法不工作
```bash
# 确保环境变量正确
echo $GTK_IM_MODULE  # 应该是 fcitx
echo $QT_IM_MODULE   # 应该是 fcitx

# 重启 fcitx5
pkill fcitx5
fcitx5 &
```

#### 3. 电源管理冲突
如果遇到 TLP 和其他电源管理工具冲突：
```bash
# 查看运行中的电源管理服务
systemctl list-units | grep power

# 只保留 TLP
sudo systemctl disable power-profiles-daemon
sudo systemctl stop power-profiles-daemon
```

#### 4. Python 包缺失
```bash
# 方法 1：添加到 configuration.nix 的 Python 包列表
# 方法 2：使用 pip 在虚拟环境中安装
python3 -m venv myenv
source myenv/bin/activate
pip install package-name
```

#### 5. 显卡驱动问题
编辑 `hardware-configuration.nix`，根据你的显卡类型启用相应驱动。

### 获取帮助

- NixOS 官方文档：https://nixos.org/manual/nixos/stable/
- NixOS Wiki：https://nixos.wiki/
- NixOS 中文社区：https://discourse.nixos.org/
- Home Manager 文档：https://nix-community.github.io/home-manager/

## 📝 自定义配置

### 添加新软件

编辑 `configuration.nix`：
```nix
environment.systemPackages = with pkgs; [
  # 在这里添加新软件包名称
  new-package
];
```

### 修改电源设置

编辑 `configuration.nix` 中的 `services.tlp.settings` 部分。

### 更改桌面环境

如果想使用 XFCE 而不是 GNOME，编辑 `configuration.nix`：
```nix
services.xserver = {
  enable = true;
  # displayManager.gdm.enable = true;
  # desktopManager.gnome.enable = true;
  
  # 改为 XFCE
  displayManager.lightdm.enable = true;
  desktopManager.xfce.enable = true;
};
```

### 个性化 Home Manager

编辑 `home.nix` 来自定义：
- Shell 别名和配置
- 编辑器设置
- Git 配置
- 终端主题

## 🎓 学习资源

### NixOS 学习
- [NixOS 官方教程](https://nixos.org/learn.html)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [nix.dev](https://nix.dev/)

### Python 数据科学
- [NumPy 教程](https://numpy.org/doc/stable/user/quickstart.html)
- [Pandas 文档](https://pandas.pydata.org/docs/)
- [Matplotlib 教程](https://matplotlib.org/stable/tutorials/index.html)
- [Jupyter 文档](https://jupyter.org/documentation)

### C 语言
- [C 语言教程](https://www.learn-c.org/)
- [GDB 调试指南](https://www.gnu.org/software/gdb/documentation/)
- [CMake 教程](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)

### LaTeX
- [LaTeX 入门](https://www.overleaf.com/learn)
- [一份不太简短的 LaTeX2e 介绍](http://mirrors.ctan.org/info/lshort/chinese/lshort-zh-cn.pdf)

## 📄 许可证

本配置基于 MIT 许可证。

## 🤝 贡献

欢迎提出问题和改进建议！

---

**祝学习愉快！ 📚✨**
