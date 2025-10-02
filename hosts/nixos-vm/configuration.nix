{
  config,
  inputs,
  pkgs,
  lib,
  username,
  hostname,
  ...
}: let
  user = "${username}";
  keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8iAnIaa1deoc7jw8YACPNVka1ZFJxhnU4G74TmS+p"];
in {
  # Start with this simple test
  imports = [
    ./disk-config.nix
    # ../modules/shared
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 42; # From template
      };
      efi.canTouchEfiVariables = true;
    };

    # Merged kernel modules (template + Apple Virtualization)
    initrd.availableKernelModules = [
      # From template (USB, SATA support)
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      # Apple Virtualization essentials
      "virtio_pci"
      "virtio_blk"
      "virtiofs"
    ];

    # From template
    kernelPackages = pkgs.linuxPackages_6_6;
    kernelModules = ["uinput"];

    # Performance optimizations for Apple Virtualization
    kernelParams = [
      "elevator=noop"
      "mitigations=off"
    ];

    # Memory and I/O optimizations
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;
    };
  };

  # Essential services
  services = {
    fstrim.enable = true; # SSD maintenance
    earlyoom.enable = true; # Prevent memory exhaustion
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "${hostname}"; # Define your hostname.
    useDHCP = false;
    interfaces."enp0s1".useDHCP = true;
  };

  # Turn on flag for proprietary software
  nix = {
    # nixPath = ["nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos"];
    settings = {
      allowed-users = ["${user}"];
      trusted-users = ["@admin" "${user}"];
    };

    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Manages keys and such
  programs = {
    # My shell
    zsh.enable = true;
  };

  virtualisation.rosetta.enable = true;

  services = {
    desktopManager.plasma6.enable = true;
    spice-vdagentd.enable = true;
    displayManager.sddm.wayland.enable = true;
    displayManager.sddm.enable = true;

    # xserver = {
    #   enable = false;
    #
    #   xkb = {
    #     # Turn Caps Lock into Ctrl
    #     layout = "us";
    #     options = "ctrl:nocaps";
    #   };

    # Better support for general peripherals
    libinput.enable = true;

    # Let's be able to SSH into this machine
    openssh.enable = true;

    # Sync state between machines
    # syncthing = {
    #   enable = true;
    #   openDefaultPorts = true;
    #   dataDir = "/home/${user}/.local/share/syncthing";
    #   configDir = "/home/${user}/.config/syncthing";
    #   user = "${user}";
    #   group = "users";
    #   guiAddress = "127.0.0.1:8384";
    #   overrideFolders = true;
    #   overrideDevices = true;
    #
    #   settings = {
    #     devices = {};
    #     options.globalAnnounceEnabled = false; # Only sync on LAN
    #   };
    # };

    #   # Emacs runs as a daemon
    #   emacs = {
    #     enable = true;
    #     package = pkgs.emacs-unstable;
    #   };
  };

  # When emacs builds from no cache, it exceeds the 90s timeout default
  # systemd.user.services.emacs = {
  # serviceConfig.TimeoutStartSec = "7min";
  # };

  # Enable sound
  # sound.enable = true;

  # Video support
  hardware = {
    graphics.enable = true;
    # pulseaudio.enable = true;
  };

  # It's me, it's you, it's everyone
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };

    root = {
      openssh.authorizedKeys.keys = keys;
    };
  };

  # Don't require password for users in `wheel` group for these commands
  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = ["NOPASSWD"];
          }
        ];
        groups = ["wheel"];
      }
    ];
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
    emacs-all-the-icons-fonts
    jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-emoji
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = "21.05"; # Don't change this
}
