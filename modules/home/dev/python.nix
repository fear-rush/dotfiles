{pkgs, ...}: {
  # Python development environment
  # Uses uv as the package/project manager (fast, modern replacement for pip/poetry)

  home.packages = with pkgs; [
    # Python interpreter
    python313

    # uv - extremely fast Python package installer and resolver
    # Replaces pip, pip-tools, pipx, poetry, pyenv, virtualenv
    uv

    # Additional tools
    ruff # Fast Python linter and formatter (replaces black, isort, flake8)
  ];

  # Environment variables for Python
  home.sessionVariables = {
    # Use uv for pip operations
    PIP_REQUIRE_VIRTUALENV = "true";
    # Disable pip version check (managed by Nix)
    PIP_DISABLE_PIP_VERSION_CHECK = "1";
  };
}
