{pkgs, ...}: {
  # Java development environment
  # Replaces sdkman with declarative Nix-managed JDK

  home.packages = with pkgs; [
    # JDK 21 LTS (Temurin/Eclipse Adoptium)
    temurin-bin-21

    # Build tools
    maven
    gradle

    # Development tools
    jdt-language-server # Eclipse JDT Language Server for IDE support
  ];

  # Java environment configuration
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.temurin-bin-21}";
  };
}
