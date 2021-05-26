{ config, pkgs, callPackage, ... }:

# [
#   (import (builtins.fetchTarball
#     "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
# ]

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./vim.nix
    # ./starship.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    version = 2;
    devices = [ "nodev" ];
    useOSProber = true;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Fortaleza";

  networking.useDHCP = false;
  networking.interfaces = {
    ens1f1.useDHCP = true;
    wlp3s0.useDHCP = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Inconsolata";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  environment.pathsToLink = [ "/libexec" ];
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [ i3status i3lock i3blocks ];
    #extraPackages = with pkgs; [ dmenu i3status i3lock i3blocks ];
  };

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # terminal stuff
    wget
    vim
    doas
    zsh
    ion
    exa
    alacritty
    tmux
    fzf
    fd
    starship
    asciinema

    # dev/related
    cht-sh
    docker
    cmake
    automake
    gnumake
    nixfmt
    git
    emacs
    rustup
    carnix
    ruby
    gcc
    shellcheck
    python3
    pipenv
    python38Packages.pip
    python38Packages.black
    python38Packages.isort
    python38Packages.nose
    python38Packages.pyflakes
    python38Packages.pytest
    python38Packages.setuptools
    black
    xdotool
    xclip
    xorg.xwininfo

    # base
    linux
    grub
    systemd
    opera
    qutebrowser
    tdesktop
    gammy
    keynav
    discord
    xorg.xmodmap
    xcompmgr
    # fonts
    inconsolata
    hack-font
    terminus
  ];
  #RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  
  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "doce" ];
      keepEnv = true;
      persist = true;
    }];
  };

  virtualisation.docker.enable = true;

  #programs.zsh.enable = true;
  users.extraUsers.doce = { shell = pkgs.ion; };
  users.users.doce = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "dhcpcd" ];
  };

  # options.programs.starship = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   settings = {
  #     add_newline = false;

  #     character = {
  #       success_symbol = "";
  #       error_symbol = " X (bold red)";
  #     };

  #     package.disabled = true;
  #   };
  # };

  system.stateVersion = "20.09"; # Did you read the comment?

}

