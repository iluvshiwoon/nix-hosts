{
  description = "Shared configuration for all my machines";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    zen-browser.url = "github:youwen5/zen-browser-flake";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    home-manager,
    nixpkgs,
    disko,
    lix-module,
    ...
  } @ inputs: let
    inherit (self) outputs;
    
    # Define your machines and their configurations
    machines = {
      macbook = {
        system = "aarch64-darwin";
        username = "kershuen";
        hostname = "macbook";
        type = "darwin";
        hostPath = "hosts/macbook";
      };
      school = {
        system = "x86_64-linux"; 
        username = "kgriset";
        # No hostname specified - will be determined at runtime
        hostname = null;
        type = "home-manager-only";
        hostPath = "hosts/school";
      };
      nixos-vm = {
        system = "aarch64-linux";
        username = "kershuen";
        hostname = "nixos-vm";
        type = "nixos";
        hostPath = "hosts/nixos-vm";
      };
    };

    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    darwinSystems = ["aarch64-darwin" "x86_64-darwin"];
    forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
    
    # Helper function to create machine-specific modules
    createMachineModules = machine: [
      # Always include shared configuration
      ./shared
      # Include host-specific config if it exists
      ./${machine.hostPath}/configuration.nix
    ];
    
  in {
    # Your custom packages
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    
    # Formatter for your nix files
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    
    # Reusable home-manager modules
    homeManagerModules = import ./modules/home-manager;
    
    # Reusable darwin modules  
    darwinModules = import ./modules/darwin;

    # Darwin configurations (macOS with nix-darwin)
    darwinConfigurations = builtins.listToAttrs (
      builtins.map (machineName: let
        machine = machines.${machineName};
      in {
        name = machine.hostname;
        value = darwin.lib.darwinSystem {
          system = machine.system;
          specialArgs = {
            inherit inputs outputs;
            username = machine.username;
            hostname = machine.hostname;
            machineConfig = machine;
          };
          modules = [
            inputs.nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                user = machine.username;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
          ] ++ createMachineModules machine;
        };
      }) (builtins.filter (name: machines.${name}.type == "darwin") (builtins.attrNames machines))
    );

    # NixOS configurations
    nixosConfigurations = builtins.listToAttrs (
      builtins.map (machineName: let
        machine = machines.${machineName};
      in {
        name = machine.hostname;
        value = nixpkgs.lib.nixosSystem {
          system = machine.system;
          specialArgs = {
            inherit inputs outputs;
            username = machine.username;
            hostname = machine.hostname;
            machineConfig = machine;
          };
          modules = [
            disko.nixosModules.disko
            lix-module.nixosModules.default
          ] ++ createMachineModules machine;
        };
      }) (builtins.filter (name: machines.${name}.type == "nixos") (builtins.attrNames machines))
    );

    # Standalone home-manager configurations
    homeConfigurations = builtins.listToAttrs (
      builtins.concatMap (machineName: let
        machine = machines.${machineName};
      in 
        if machine.hostname != null then [
          # Configuration with hostname (for known hostnames)
          {
            name = "${machine.username}@${machine.hostname}";
            value = home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${machine.system};
              extraSpecialArgs = {
                inherit inputs outputs;
                username = machine.username;
                hostname = machine.hostname;
                machineConfig = machine;
              };
              modules = [
                ./shared/home.nix
                ./${machine.hostPath}/home.nix
              ];
            };
          }
        ] else [
          # Configuration without hostname (for dynamic hostnames like school)
          {
            name = machine.username;
            value = home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${machine.system};
              extraSpecialArgs = {
                inherit inputs outputs;
                username = machine.username;
                hostname = null; # Will be detected at runtime
                machineConfig = machine;
              };
              modules = [
                ./shared/home.nix
                ./${machine.hostPath}/home.nix
              ];
            };
          }
        ]
      ) (builtins.attrNames machines)
    );
  };
}
