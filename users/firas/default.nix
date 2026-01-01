{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Shell configuration
    ../../modules/home/shell/zsh.nix
    ../../modules/home/shell/starship.nix
    ../../modules/home/shell/git.nix

    # Terminal configuration
    ../../modules/home/terminal/ghostty.nix

    # Development tools (Phase 2)
    ../../modules/home/dev/node.nix
    ../../modules/home/dev/python.nix
    ../../modules/home/dev/go.nix
    ../../modules/home/dev/rust.nix
    ../../modules/home/dev/php.nix
    ../../modules/home/dev/java.nix

    # Shared packages
    ../../modules/shared/packages.nix
  ];

  # Home Manager needs this
  home = {
    username = "firas";
    homeDirectory = "/Users/firas";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    stateVersion = "24.11";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
