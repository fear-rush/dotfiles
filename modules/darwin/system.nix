{pkgs, ...}: {
  # macOS system preferences managed by nix-darwin

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
        autohide-delay = 0.0; # Remove delay for showing dock
        autohide-time-modifier = 0.2; # Speed up dock animation
        show-recents = false;
        mru-spaces = false; # Don't rearrange spaces based on most recent use
        minimize-to-application = true; # Minimize windows into app icon
        launchanim = false; # Disable launch animation
        # Position: "left", "bottom", "right"
        orientation = "bottom";
        tilesize = 48; # Dock icon size
        # Hot corners
        # Options: 1=disabled, 2=Mission Control, 3=App Windows, 4=Desktop,
        # 5=Start Screensaver, 6=Disable Screensaver, 7=Dashboard,
        # 10=Sleep Display, 11=Launchpad, 12=Notification Center, 13=Lock Screen
        wvous-tl-corner = 1; # Top left - disabled
        wvous-tr-corner = 1; # Top right - disabled
        wvous-bl-corner = 1; # Bottom left - disabled
        wvous-br-corner = 1; # Bottom right - disabled
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false; # Show hidden files (toggle with Cmd+Shift+.)
        ShowPathbar = true;
        ShowStatusBar = true;
        FXEnableExtensionChangeWarning = false;
        # Default view: "icnv" (icons), "Nlsv" (list), "clmv" (column), "Flwv" (gallery)
        FXPreferredViewStyle = "clmv";
        # Search scope: "SCcf" (current folder), "SCsp" (previous scope), "SCev" (everywhere)
        FXDefaultSearchScope = "SCcf";
        _FXShowPosixPathInTitle = true; # Show full path in title
        _FXSortFoldersFirst = true; # Keep folders on top when sorting
      };

      # Login window
      loginwindow = {
        GuestEnabled = false; # Disable guest account
      };

      # Menu bar clock
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1; # 0=when space allows, 1=always, 2=never
        ShowDayOfWeek = true;
        ShowSeconds = false;
      };

      # Screensaver
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 5; # Seconds before password required
      };

      # Screenshot settings
      screencapture = {
        location = "~/Pictures/Screenshots";
        type = "png"; # png, jpg, gif, pdf, tiff
        disable-shadow = true; # Disable shadow in screenshots
      };

      # Global macOS settings
      NSGlobalDomain = {
        # Expand save panel by default
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;

        # Expand print panel by default
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;

        # Keyboard repeat rate (lower = faster)
        KeyRepeat = 2;
        InitialKeyRepeat = 15;

        # Disable automatic capitalization, spelling correction
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;

        # Enable full keyboard access for all controls (Tab in dialogs)
        AppleKeyboardUIMode = 3;

        # Disable press-and-hold for keys (enables key repeat)
        ApplePressAndHoldEnabled = false;

        # Finder: show all filename extensions
        AppleShowAllExtensions = true;

        # Show scroll bars: "WhenScrolling", "Automatic", "Always"
        AppleShowScrollBars = "Automatic";

        # Use metric units
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleTemperatureUnit = "Celsius";

        # Interface style: null=light, "Dark"=dark
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true; # Tap to click
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true; # Three finger drag
      };

      # Custom user defaults
      CustomUserPreferences = {
        # Disable Disk Image verification
        "com.apple.frameworks.diskimages" = {
          skip-verify = true;
          skip-verify-locked = true;
          skip-verify-remote = true;
        };

        # Avoid creating .DS_Store files on network or USB volumes
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        # Enable developer menu in Safari
        "com.apple.Safari" = {
          IncludeDevelopMenu = true;
          WebKitDeveloperExtrasEnabledPreferenceKey = true;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
        };

        # Prevent Time Machine from prompting for new disks
        "com.apple.TimeMachine" = {
          DoNotOfferNewDisksForBackup = true;
        };

        # Activity Monitor: show all processes
        "com.apple.ActivityMonitor" = {
          ShowCategory = 0;
        };

        # TextEdit: use plain text mode by default
        "com.apple.TextEdit" = {
          RichText = 0;
          PlainTextEncoding = 4;
          PlainTextEncodingForWrite = 4;
        };
      };
    };
  };

  # Security settings
  security.pam.services.sudo_local.touchIdAuth = true;
}
