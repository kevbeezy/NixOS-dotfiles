{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  toggleFile = /home/joachim/.nixos-toggles.json;
  defaultToggles = {
    nvidia = false;
    tools = true;
    arduino = false;
    game = false;
    mango = true;
    plasma = false;
  };
  toggles =
    if builtins.pathExists toggleFile then
      builtins.fromJSON (builtins.readFile toggleFile)
    else
      defaultToggles;
in

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    inputs.mangowm.nixosModules.mango
  ]
  ++ lib.optional toggles.arduino ./arduino-dev.nix
  ++ lib.optional toggles.game ./game.nix;
  programs.mango.enable = lib.mkIf toggles.mango true;
  services.desktopManager.plasma6.enable = lib.mkIf toggles.plasma true;
  services.xserver.videoDrivers = if toggles.nvidia then [ "nvidia" ] else [ "amdgpu" ];
  hardware.nvidia = lib.mkIf toggles.nvidia {
    modesetting.enable = true;
    open = false;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
    users.joachim = import ./home.nix;
    backupFileExtension = "bak";
  };

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  virtualisation.docker.enable = true;

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  boot.kernelPackages = pkgs.lib.mkDefault pkgs.linuxPackages_latest;

  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "usbcore.autosuspend=-1"
  ];
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  hardware.bluetooth.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;

  services.displayManager.sddm.enable = false;

  services.displayManager.plasma-login-manager = {
    enable = false;
    settings = {
      Users = {
        ReuseSession = true;
      };
    };
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      save = true;
      load = true;
      animation = "doom";
    };
  };

  services.displayManager.defaultSession = "mango";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."joachim" = {
    isNormalUser = true;
    description = "Joachim";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    jq
    wget
    fastfetch
    stow
    yazi
    zoxide
    pavucontrol
    bat
    kdePackages.yakuake
    vesktop
    neovide
    pear-desktop
    wl-clipboard
    eza
    pkgs.nixfmt
    pkgs.nixd
    inputs.kwin-blur.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    maple-mono.NF-CN
  ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };
  system.stateVersion = "26.05"; # Did you read the comment?

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.shellAliases = {
    nixupdate = "find $HOME/.dotfiles -name \"*.nix\" -exec nixfmt {} + && sudo nix flake update --flake $HOME/.dotfiles --impure";
    nixrebuild = "find $HOME/.dotfiles -name \"*.nix\" -exec nixfmt {} + && sudo nixos-rebuild switch --flake $HOME/.dotfiles#joachim --impure";
    nixupgrade = "find $HOME/.dotfiles -name \"*.nix\" -exec nixfmt {} + && sudo nix flake update --flake $HOME/.dotfiles && sudo nixos-rebuild switch --flake $HOME/.dotfiles#joachim --impure";

    ls = "eza -algF --header --extended --octal-permissions --group-directories-first --time-style=long-iso --color=always --git --icons=always";

    nixconf = "nvim $HOME/.dotfiles/configuration.nix";
    nixflake = "nvim $HOME/.dotfiles/flake.nix";
    nixhome = "nvim $HOME/.dotfiles/home.nix";
  };

  environment.variables = {
    TERMINAL = "kitty";
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
