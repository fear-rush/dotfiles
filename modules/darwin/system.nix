{pkgs, ...}: {
  # macOS system preferences managed by nix-darwin
  # These will be expanded in Phase 4

  system = {
    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = false; # Set to true if you want this
    };

    # System defaults (Finder, Dock, etc.)
    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        show-recents = false;
        mru-spaces = false;
        # Position: "left", "bottom", "right"
        orientation = "bottom";
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        FXEnableExtensionChangeWarning = false;
        # Default view: "icnv" (icons), "Nlsv" (list), "clmv" (column), "Flwv" (gallery)
        FXPreferredViewStyle = "clmv";
      };

      # Global macOS settings
      NSGlobalDomain = {
        # Expand save panel by default
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;

        # Keyboard repeat rate (lower = faster)
        KeyRepeat = 2;
        InitialKeyRepeat = 15;

        # Disable automatic capitalization, spelling correction
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true; # Tap to click
        TrackpadRightClick = true;
      };
    };
  };

  # Security settings
  security.pam.services.sudo_local.touchIdAuth = true;
}
