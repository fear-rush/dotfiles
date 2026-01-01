{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  # SOPS-nix configuration for secrets management
  # Uncomment and configure once you've set up your age key
  #
  # Setup instructions:
  # 1. Generate age key: mkdir -p ~/.config/sops/age && age-keygen -o ~/.config/sops/age/keys.txt
  # 2. Get public key: age-keygen -y ~/.config/sops/age/keys.txt
  # 3. Update secrets/.sops.yaml with your public key
  # 4. Create and encrypt secrets: sops secrets/secrets.yaml

  sops = {
    # Path to the age key file
    age.keyFile = "/Users/firas/.config/sops/age/keys.txt";

    # Default settings for all secrets
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # Validate at build time that sops files can be decrypted
    validateSopsFiles = false; # Set to true once secrets.yaml exists

    # Define your secrets here (uncomment when ready)
    # secrets = {
    #   "github_token" = {
    #     # Owner of the secret file
    #     owner = "firas";
    #     # Secret will be available at this path
    #     path = "/run/secrets/github_token";
    #   };
    #
    #   "openai_api_key" = {
    #     owner = "firas";
    #   };
    #
    #   "db_password" = {
    #     owner = "firas";
    #   };
    # };
  };
}
