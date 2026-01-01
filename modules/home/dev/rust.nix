{pkgs, ...}: {
  # Rust development environment
  # Uses rustup for toolchain management (allows switching between stable/nightly)

  home.packages = with pkgs; [
    # Rustup for toolchain management
    # After rebuild, run: rustup default stable
    rustup

    # Build dependencies (needed for compiling Rust projects)
    pkg-config
    openssl

    # Additional tools (these work alongside rustup-managed tools)
    cargo-watch # Watch for changes and rebuild
    cargo-edit # Add/remove/upgrade dependencies
    cargo-nextest # Better test runner
    cargo-audit # Security vulnerability scanner
  ];

  # Rust environment configuration
  home.sessionVariables = {
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
  };

  # Add cargo bin to PATH
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}
