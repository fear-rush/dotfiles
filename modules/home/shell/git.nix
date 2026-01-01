{pkgs, ...}: {
  programs.git = {
    enable = true;

    # Git settings (new format for home-manager)
    settings = {
      user = {
        name = "muhammadfiras";
        email = "muhfiras1@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;

      # Better diffs
      diff.algorithm = "histogram";

      # Merge conflict style
      merge.conflictstyle = "zdiff3";

      # Reuse recorded resolution
      rerere.enabled = true;

      # Use SSH for GitHub
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };

      # Core settings
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
    };

    # Ignore patterns
    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv/"
      ".envrc"
      "result"
      "result-*"
    ];
  };

  # Delta for better diffs (separate program now)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      syntax-theme = "Dracula";
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  # SSH configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Match blocks for SSH hosts
    matchBlocks = {
      # Default settings for all hosts
      "*" = {
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
          IgnoreUnknown = "UseKeychain";
        };
      };

      # GitHub specific
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };

  # Lazygit for TUI git management
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
        theme = {
          lightTheme = false;
        };
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
