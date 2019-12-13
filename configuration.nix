# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  #boot.loader.gummiboot.enable = true;
  boot.loader.systemd-boot.enable = true; #new form
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_4_19;

  networking.hostName = "nixhost"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
   i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "pl";
     defaultLocale = "en_US.UTF-8";
   };

  # Set your time zone.
    time.timeZone = "Europe/Warsaw";

  # Bluetooth
  hardware.bluetooth.enable = false;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
     vim
     vimPlugins.pathogen
     ethtool
     nox
     pciutils
     terminator
     tmux
     powertop
     openssh
     dmidecode
     chromium
     #networkmanagerapplet
     xorg.xbacklight
     ethtool
     gnupg
     psmisc
     docker
     which
     avahi
     acpitool
     gitAndTools.gitFull
     wget
     evince
     binutils
     cpufrequtils
     xfce.xfwm4
     telnet
     tightvnc
     unzip
     unrar
     bc
     unetbootin
     unrar
     xournal
     mc
  ];

  # Sound config for B&O audio
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.extraConfig = ''
    load-module module-equalizer-sink
    load-module module-dbus-protocol
  '';
  #sound.extraConfig = ''
  #   options snd-hda-intel model=auto position_fix=0
  #'';

  # Set common environment variables
  environment.variables.EDITOR = "vim";

  # Enable browsers plugins
  nixpkgs.config = {

    allowUnfree = true;

########################################################
## This part should install browsers flash plugin
## But as the flashplugin is often outdated, and source no more available,
## it may break the nixos-rebuild on updates. Solution is to use the unstable channel.
## So, I prefer doing this outside the configuration.nix by using the system wide root profile:
##     [root@bart:~]# nix-channel --add https://nixos.org/channels/nixos-unstable unstable
##     [root@bart:~]# echo "{ chromium = { enablePepperFlash = true; }; }" > ~/.nixpkgs/config.nix
##     [root@bart:~]# nix-env -i -A unstable.chromium
########################################################
##
#    firefox = {
#     enableGoogleTalkPlugin = true;
#     enableAdobeFlash = true;
#     jre = true;
#    };

#    chromium = {
#     enablePepperFlash = true; # Chromium removed support for Mozilla (NPAPI) plugins so Adobe Flash no longer works
#     enablePepperPDF = true;
#     jre = true;
#    };
#
## Attempt to solve the outdated flash plugin file download failure:
#    packageOverrides = pkgs: rec {
#       flashplayer-ppapi = pkgs.stdenv.lib.overrideDerivation pkgs.flashplayer-ppapi (oldAttrs: {
#          name = "flashplayer-ppapi";
#          src = pkgs.fetchurl {
#            url = "https://fpdownload.adobe.com/pub/flashplayer/pdc/27.0.0.130/flash_player_ppapi_linux.x86_64.tar.gz";
#            sha256 = "1bl4y665a4rq4pw67pl3hyd4234p9j8lgv2853jh2pk5gbmdz6xw";
#          };
#       });
#    };
#
# #####################################################
};


  # Enable docker virtualization
  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
    services.printing.enable = true;

  # For network printing
    services.avahi.enable = true;
    services.printing.browsing = true;
    services.printing.browsedConf = ''
      BrowseRemoteProtocols cups
      BrowsePoll print.imag.fr:631
    '';

  # Enable the X11 windowing system.
    services.xserver.enable = true;
    #services.xserver.videoDrivers = [ "modesetting" "intel" ];
    services.xfs.enable = false;
    fonts.enableFontDir = false;
    services.xserver.layout = "pl";
    #services.xserver.xkbVariant = "latin9";
    #services.xserver.xkbOptions = "eurosign:e";
    services.xserver.synaptics.enable = false;
    services.xserver.synaptics.twoFingerScroll = false;
    services.xserver.exportConfiguration = true;
    services.xserver.displayManager.sessionCommands = ''
      # Start network manager applet
      #${pkgs.networkmanagerapplet}/bin/nm-applet &
      # Make the Meta key act into KDE like into Gnome
      ksuperkey -e "Super_L=Control_L|F8"
      '';


  # Enable the KDE Desktop Environment.
   #services.xserver.displayManager.sddm.enable = true;
   #services.xserver.desktopManager.plasma5.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome3.enable = true;

  # Enable network manager
  #  networking.networkmanager.enable = true;

  # Enable parallel build
  nix.maxJobs = 8 ;

  # Virtualbox
  # virtualisation.virtualbox.host.enable = true;

  #
  nix.useSandbox = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "19.09";

  services.locate.enable = true;

}
