{
  description = "Firas's Nix Configuration for macOS and Linux";

  inputs = {
    # Core nixpkgs - using unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin for macOS system configuration
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim for Neovim configuration (Phase 3)
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix for secrets management (Phase 4)
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ghostty terminal - official flake
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixvim,
    sops-nix,
    ghostty,
    ...
  }: let
    # Supported systems
    systems = {
      darwin = "aarch64-darwin"; # Apple Silicon
      linux = "x86_64-linux"; # Future Linux machines
    };

    # Helper function to create darwin configurations
    mkDarwinHost = hostname: {
      system,
      modules ? [],
    }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs self;};
        modules =
          [
            # Base darwin configuration
            ./hosts/${hostname}

            # Home-manager as a darwin module
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {inherit inputs self;};
                # Backup existing dotfiles before overwriting
                backupFileExtension = "backup";
                users.firas = import ./users/firas;
              };
            }
          ]
          ++ modules;
      };
  in {
    # Darwin (macOS) configurations
    darwinConfigurations = {
      # Main machine
      maryln = mkDarwinHost "maryln" {
        system = systems.darwin;
      };
    };

    # Expose overlays for nixpkgs customizations (future use)
    overlays = import ./lib/overlays.nix {inherit inputs;};

    # Development shells (optional, for project-specific environments)
    devShells = nixpkgs.lib.genAttrs ["aarch64-darwin" "x86_64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          nil # Nix LSP
          nixfmt-rfc-style # Nix formatter
        ];
      };
    });
  };
}
