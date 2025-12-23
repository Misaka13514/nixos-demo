# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # ================================================================
  # 1. 引导与内核 (Boot & Kernel)
  # ================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # 限制条目数量
  boot.loader.efi.canTouchEfiVariables = true;

  # 使用 Zen 内核
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernel.sysctl."kernel.sysrq" = 1;

  # 启用 Plymouth 启动动画
  boot.plymouth.enable = true;

  # ================================================================
  # 2. 硬件与电源管理 (Hardware & Power)
  # ================================================================
  # 启用全部固件
  hardware.enableAllFirmware = true;

  # 蓝牙支持
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # 传感器支持
  hardware.sensor.iio.enable = true;

  # Intel CPU 电源管理
  services.thermald.enable = true;

  # GNOME 默认电源管理
  services.power-profiles-daemon.enable = true;

  # 内存优化
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # ================================================================
  # 3. 网络 (Networking)
  # ================================================================
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # 关闭防火墙
  networking.firewall.enable = false;

  # Avahi (mDNS/局域网发现)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
      workstation = true;
    };
  };

  # ================================================================
  # 4. 本地化与字体 (Locale & Fonts)
  # ================================================================
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # 输入法：IBus + 智能拼音
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      libpinyin
    ];
  };

  # 字体配置
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      sarasa-gothic
      wqy_microhei
      inter
      fira-code
      nerd-fonts.fira-code
      nerd-fonts.symbols-only
    ];

    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif CJK SC"
        "Source Han Serif SC"
        "Symbols Nerd Font"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Noto Sans CJK SC"
        "Source Han Sans SC"
        "Symbols Nerd Font"
        "Noto Color Emoji"
      ];
      monospace = [
        "Sarasa Mono SC"
        "Noto Sans Mono CJK SC"
        "Symbols Nerd Font Mono"
        "Noto Color Emoji"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # ================================================================
  # 5. 桌面环境 (Desktop Environment)
  # ================================================================
  services.xserver.enable = true;

  # GNOME
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # 触摸板/触屏手势支持
  services.libinput.enable = true;

  # 键盘布局
  services.xserver.xkb = {
    layout = "jp,us";
    model = "jp106";
    options = "grp:alt_shift_toggle";
  };

  console.useXkbConfig = true;

  # 环境变量：强制 Wayland 和触控优化
  environment.sessionVariables = {
    "NIXOS_OZONE_WL" = "1";
    "MOZ_ENABLE_WAYLAND" = "1";
    "MOZ_WEBRENDER" = "1";
    "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
    "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
    "QT_QPA_PLATFORM" = "wayland";
    "SDL_VIDEODRIVER" = "wayland";
    "GDK_BACKEND" = "wayland";
    "XDG_SESSION_TYPE" = "wayland";
  };

  # GNOME 外设
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # ================================================================
  # 6. 音频与打印 (Audio & Services)
  # ================================================================
  services.printing.enable = true;

  # Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ================================================================
  # 7. 软件与应用 (Packages & Programs)
  # ================================================================
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    rnote
    foliate
    gromit-mpx
    mission-center
    clapper
    vlc
    mpv

    gnome-tweaks
    adw-gtk3
    dconf-editor

    usbutils
    pciutils
    lshw
    dmidecode
    lm_sensors

    ldns
    curl
    wget
    mtr
    nmap
    iperf3
    ethtool

    ripgrep
    fd
    bat
    eza

    git
    killall
    lsof
    file
    tree
    p7zip

    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator

    fastfetch
    hyfetch
    btop
    htop
    wl-clipboard

    chromium
    firefox
    ayugram-desktop
    telegram-desktop

    nh
    nixd
    nixfmt-rfc-style
    nix-output-monitor
    nix-tree
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        editorconfig.editorconfig
        esbenp.prettier-vscode
        jnoortheen.nix-ide
        ms-azuretools.vscode-docker
        ms-python.python
      ];
    })
  ];

  # 程序配置
  programs.git.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # Shell
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Nix Index / Command Not Found
  programs.nix-index-database.comma.enable = true;
  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.firefox.enable = true;
  programs.steam.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;

  # ================================================================
  # 8. 用户与权限 (Users)
  # ================================================================
  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    extraGroups = [
      "wheel"
      "video"
      "docker"
      "networkmanager"
      "input"
      "wireshark"
      "libvirtd"
    ];
    shell = pkgs.fish;
    initialPassword = "nixos";
  };
  security.sudo.wheelNeedsPassword = false;

  # ================================================================
  # 9. Nix 核心配置 (Nix Settings)
  # ================================================================
  nix = {
    channel.enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://mirror.iscas.ac.cn/nix-channels/store"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "25.11";
}
