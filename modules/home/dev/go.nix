{pkgs, ...}: {
  # Go development environment

  home.packages = with pkgs; [
    # Go compiler and tools
    go

    # Development tools
    gopls # Go language server
    golangci-lint # Linter aggregator
    delve # Debugger
    gotools # Additional tools (goimports, etc.)
  ];

  # Go environment configuration
  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
  };

  # Add Go bin to PATH
  home.sessionPath = [
    "$HOME/go/bin"
  ];
}
