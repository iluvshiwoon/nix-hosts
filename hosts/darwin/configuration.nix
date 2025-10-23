# This is your nix-darwin configuration file
{
  inputs,
  outputs,
  lib,
  username,
  hostname,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./system-settings.nix
  ];
  # ] ++ (builtins.attrValues outputs.darwinModules); # list: value of attr in set

  ids.gids.nixbld = 350;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # Make nix commands consistent with the flake
  nix.nixPath = [{nixpkgs = "${inputs.nixpkgs}";}];

  # Nix configuration
  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    trusted-users = ["${username}"];
    # Deduplicate and optimize nix store
  };
  nix.optimise.automatic = true;

  # Enable garbage collection to happen automatically
  nix.gc = {
    automatic = true;
    interval = {Day = 7;};
    options = "--delete-older-than 7d";
  };

  # Set your time zone
  #time.timeZone = "Europe/Paris";

  # Set your hostname
  networking.hostName = "${hostname}";

  # Install system-wide packages
  environment.systemPackages = with pkgs; [
    git
    vim
  ];
  homebrew = {
    enable = true;

    global.autoUpdate = false;
    onActivation = {
      #      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      # TODO Feel free to add your favorite apps here.

      # Xcode = 497799835;
      # Wechat = 836500024;
      # NeteaseCloudMusic = 944848654;
      # QQ = 451108668;
      # WeCom = 1189898970;  # Wechat for Work
      # TecentMetting = 1484048379;
      # QQMusic = 595615424;
      # Bitwarden = 1352778147;
    };

    taps = builtins.attrNames config.nix-homebrew.taps;

    # `brew install`
    brews = [
      "cmake"
      "pipx"
      "wget" # download tool
      # "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      "mas"
      "fzf"
      "gemini-cli"
    ];

    # `brew install --cask`
    casks = [
    "helium-browser"
      "actual"
      "docker-desktop"
      "ghostty"
      "cursor"
      "utm"
      "zen"
      "steam"
      "tor-browser"
      "iluvshiwoon/homebrew-additional/ryujinx"
    ];
  };

  # Configure shell - ZSH comes by default on macOS
  programs.zsh.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enableCompletion = true;
  programs.zsh.enableBashCompletion = true;

  # Set up a default user
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
}
