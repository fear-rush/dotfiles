{...}: {
  # Homebrew management via nix-darwin
  # This allows declarative management of Homebrew casks (GUI apps)

  homebrew = {
    enable = true;

    # Behavior settings
    onActivation = {
      # "zap" removes everything not in this config (be careful!)
      # "uninstall" removes unlisted casks
      # "none" only adds, never removes
      cleanup = "none"; # Start safe, change to "uninstall" once stable
      autoUpdate = true;
      upgrade = true;
    };

    # Taps (repositories)
    # Note: homebrew/bundle is deprecated and no longer needed
    taps = [];

    # CLI tools via Homebrew (prefer Nix packages when possible)
    brews = [
      # Only add brews that don't work well via Nix
    ];

    # GUI Applications (Casks)
    casks = [
      # Browsers
      "google-chrome"

      # Development
      "zed" # Modern editor
      "orbstack" # Docker & Linux VMs

      # API Development
      "bruno" # Open-source API client (Postman alternative)

      # Database Tools
      "tableplus" # Database GUI
      "dbngin" # Database version manager

      # Terminal
      "ghostty"

      # Communication
      "slack"
      "discord"
      "zoom"

      # Productivity
      "rectangle" # Window management
    ];

    # Mac App Store apps (requires mas CLI)
    masApps = {
      # "App Name" = APP_ID;
      # Example: "Xcode" = 497799835;
    };
  };
}
