{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Import darwin-specific modules
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
    # Secrets management (uncomment after setting up age key)
    # ../../modules/darwin/secrets.nix
  ];

  # Primary user - required for user-specific settings
  system.primaryUser = "firas";

  # Disable nix-darwin's Nix management since we use Determinate Nix
  # Determinate Nix has its own daemon that manages the Nix installation
  nix.enable = false;

  # Note: Garbage collection and store optimization are handled by
  # Determinate Nix. You can run manually:
  # - nix-collect-garbage -d  (to clean up old generations)
  # - nix store optimise      (to deduplicate store)

  # System packages available to all users
  environment.systemPackages = with pkgs; [
    # Essential tools
    vim
    git
    curl
    wget
  ];

  # Enable zsh as default shell
  programs.zsh.enable = true;

  # Set hostname
  networking.hostName = "maryln";

  # macOS version compatibility
  system.stateVersion = 5;

  # Allow unfree packages (Chrome, etc)
  nixpkgs.config.allowUnfree = true;

  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";

  # User configuration
  users.users.firas = {
    name = "firas";
    home = "/Users/firas";
    shell = pkgs.zsh;
  };
}
