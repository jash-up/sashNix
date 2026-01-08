{ config, pkgs, ... }:

{
  imports = 
    [
      ./hardware-configuration.nix
    ];
  
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "sash";

  # Flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enabling networking
  networking.networkmanager.enable = true;

  # Setting up ssh
  services.openssh.enable = true;

  # Ports
  networking.firewall.allowedTCPPorts = [ 22 2049 ];
  networking.firewall.allowedUDPPorts = [ 2049 ];

  # Preventing sleep on AC for lidSwitch
  services.displayManager.autoLogin = {
    enable = true;
    user = "ash";
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # Allowing unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allowing some unsafe packages
  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
  ];

  # Timezone
  time.timeZone = "Asia/Kolkata";

  # Locales and shit
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enabling X11 windowing server
  services.xserver.enable = true;

  # Setting up plex
  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/plex";
  };

  # Setting up jellyfin
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # enabling ailscale
  services.tailscale.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      #qemuSupport = true;
      #tcpListen = false;
    };
  };

  # Enabling GDM
  services.displayManager.gdm.enable = true;
  
  # Enabling gnome
  services.desktopManager.gnome.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "ash";
    group = "users";
    dataDir = "/home/ash/.config/syncthing";
  };

  # Enabling NFS server
  services.nfs.server = {
    enable = true;

    exports = ''
      /srv/nfs/ashShare 192.168.0.0/24(rw,sync,no_subtree_check)
    '';
  };

  # Ollama
  services.ollama = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
  };

  programs.fuse.userAllowOther = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Media group
  users.groups.media.gid = 1001;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ash = {
    isNormalUser = true;
    uid = 1000;
    description = "Arnav Hiwarkar";
    extraGroups = [ "networkmanager" "wheel" "libvirt" "kvm" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    fastfetch
    cmatrix
    keepassxc
    obsidian
    git
    tmux
    bat
    htop
    vlc
    gnomeExtensions.caffeine
    gnome-tweaks
    protonvpn-gui
    nemo
    ranger
    fzf
    tor
    aircrack-ng
    peaclock
    thunar
    gparted
    openssh
    rclone
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # Check the proper system state version
  system.stateVersion = "25.11";

}
