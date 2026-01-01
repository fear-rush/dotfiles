{pkgs, ...}: {
  # Node.js development environment
  # Replaces nvm with declarative Nix-managed Node.js

  home.packages = with pkgs; [
    # Node.js 22 LTS
    nodejs_22

    # Package managers
    pnpm
    bun

    # Development tools
    nodePackages.npm-check-updates # Update package.json dependencies
    nodePackages.typescript # TypeScript compiler
    # Note: Node.js 22.6+ has native TypeScript support (--experimental-strip-types)
    nodePackages.prettier # Code formatter
  ];

  # Environment variables for Node.js
  home.sessionVariables = {
    # Disable npm update notifier (managed by Nix)
    NPM_CONFIG_UPDATE_NOTIFIER = "false";
    # Set npm cache directory
    NPM_CONFIG_CACHE = "$HOME/.cache/npm";
  };
}
