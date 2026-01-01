{pkgs, ...}: {
  # Common CLI packages available across all machines
  home.packages = with pkgs; [
    # Core utilities
    coreutils
    findutils
    gnugrep
    gnused

    # File management
    tree
    eza # Modern ls replacement
    bat # Better cat
    fd # Better find
    ripgrep # Better grep

    # Compression
    zip
    unzip
    gzip

    # Networking
    curl
    wget
    httpie

    # JSON/YAML processing
    jq
    yq

    # Process management
    htop
    bottom # Modern htop alternative

    # Development utilities
    just # Command runner (like make)
    watchexec # File watcher
    tokei # Code statistics
    hyperfine # Benchmarking tool
    sd # Modern sed alternative
    procs # Modern ps alternative
    dust # Modern du alternative
    duf # Modern df alternative

    # Nix tools
    nil # Nix LSP
    nixfmt-rfc-style # Nix formatter
    nix-tree # Visualize nix dependencies

    # Secrets management
    age # Modern encryption tool
    sops # Secrets OPerationS
  ];

  # Eza (modern ls) configuration
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  # Bat (modern cat) configuration
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      paging = "auto";
    };
  };

  # Zoxide (smart cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
