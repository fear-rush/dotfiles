{pkgs, ...}: {
  # PHP development environment

  home.packages = with pkgs; [
    # PHP 8.3 with common extensions
    (php83.withExtensions ({
      enabled,
      all,
    }:
      enabled
      ++ [
        all.curl
        all.mbstring
        all.openssl
        all.pdo
        all.tokenizer
        all.xml
        all.zip
        all.intl
        all.bcmath
        all.gd
      ]))

    # Composer package manager
    php83Packages.composer

    # Development tools
    php83Packages.phpstan # Static analysis
    php83Packages.php-cs-fixer # Code style fixer
  ];
}
