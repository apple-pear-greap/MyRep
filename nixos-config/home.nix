# Home Manager 用户配置
# 个人环境和应用程序设置

{ config, pkgs, ... }:

{
  # Home Manager 版本
  home.stateVersion = "23.11";

  # 用户信息
  home.username = "student";
  home.homeDirectory = "/home/student";

  # ===== 用户软件包 =====
  home.packages = with pkgs; [
    # 终端增强
    zsh-powerlevel10k
    fzf
    ripgrep
    fd
    bat
    exa
    
    # 开发工具
    tmux
    
    # Python 额外工具
    python311Packages.pylint
    python311Packages.black
    python311Packages.mypy
    
    # C 语言格式化工具
    clang-tools
    
    # 文档工具
    pandoc
    
    # 笔记软件
    obsidian
    
    # 通讯
    # telegram-desktop
    # discord
  ];

  # ===== Git 配置 =====
  programs.git = {
    enable = true;
    # TODO: 修改为你的真实姓名和邮箱
    # Change these to your actual name and email
    userName = "Your Name";
    userEmail = "your.email@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # ===== ZSH 配置 =====
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "exa -l";
      la = "exa -la";
      ls = "exa";
      cat = "bat";
      
      # NixOS 快捷命令
      # TODO: 将 your-hostname 替换为你在 flake.nix 中设置的主机名
      # Replace 'your-hostname' with the hostname you set in flake.nix
      rebuild = "sudo nixos-rebuild switch --flake /home/student/nixos-config#your-hostname";
      update = "sudo nix flake update /home/student/nixos-config";
      
      # Python
      py = "python3";
      ipy = "ipython";
      
      # 常用命令
      vim = "nvim";
    };
    
    initExtra = ''
      # Powerlevel10k 主题
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      
      # 历史设置
      HISTSIZE=10000
      SAVEHIST=10000
      setopt SHARE_HISTORY
      
      # fzf 集成
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
    '';
  };

  # ===== Neovim 配置 =====
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      # 主题
      gruvbox-nvim
      
      # 文件树
      nerdtree
      
      # 状态栏
      vim-airline
      
      # Git 集成
      vim-fugitive
      
      # 语法高亮
      nvim-treesitter.withAllGrammars
      
      # LSP 支持
      nvim-lspconfig
      
      # 自动补全
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      
      # Python
      python-syntax
      
      # C/C++
      vim-clang-format
    ];
    
    extraConfig = ''
      " 基础设置
      set number
      set relativenumber
      set expandtab
      set tabstop=4
      set shiftwidth=4
      set smartindent
      set ignorecase
      set smartcase
      set incsearch
      set hlsearch
      
      " 主题
      colorscheme gruvbox
      set background=dark
      
      " NERDTree 快捷键
      nnoremap <C-n> :NERDTreeToggle<CR>
      
      " 快速保存
      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>
    '';
  };

  # ===== Kitty 终端配置 =====
  programs.kitty = {
    enable = true;
    font = {
      name = "Noto Sans Mono CJK SC";
      size = 11;
    };
    theme = "Gruvbox Dark";
    settings = {
      background_opacity = "0.95";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
  };

  # ===== VSCode 配置 =====
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Python
      ms-python.python
      ms-python.vscode-pylance
      
      # C/C++
      ms-vscode.cpptools
      
      # Git
      eamodio.gitlens
      
      # 通用
      vscodevim.vim
      
      # 主题
      jdinhlife.gruvbox
    ];
    
    userSettings = {
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'Noto Sans Mono CJK SC', monospace";
      "editor.formatOnSave" = true;
      "editor.tabSize" = 4;
      "workbench.colorTheme" = "Gruvbox Dark Hard";
      "python.linting.enabled" = true;
      "python.linting.pylintEnabled" = true;
      "python.formatting.provider" = "black";
    };
  };

  # ===== 其他程序 =====
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      # 鼠标支持
      set -g mouse on
      
      # 状态栏
      set -g status-style bg=black,fg=white
      
      # 分屏快捷键
      bind | split-window -h
      bind - split-window -v
    '';
  };

  # ===== 环境变量 =====
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
  };

  # ===== 让 Home Manager 管理自己 =====
  programs.home-manager.enable = true;
}
