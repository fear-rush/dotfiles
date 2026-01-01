{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # History configuration
    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    # Shell options
    defaultKeymap = "emacs";

    # Environment variables
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Aliases (replaces oh-my-zsh git plugin)
    shellAliases = {
      # Git aliases (common ones from oh-my-zsh git plugin)
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gb = "git branch";
      gba = "git branch -a";
      gc = "git commit -v";
      gcam = "git commit -a -m";
      gcmsg = "git commit -m";
      gco = "git checkout";
      gcb = "git checkout -b";
      gd = "git diff";
      gds = "git diff --staged";
      gf = "git fetch";
      gl = "git pull";
      glog = "git log --oneline --decorate --graph";
      gp = "git push";
      gpf = "git push --force-with-lease";
      grb = "git rebase";
      grbi = "git rebase -i";
      gst = "git status";
      gsta = "git stash push";
      gstp = "git stash pop";

      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Listing
      ls = "ls --color=auto";
      ll = "ls -la";
      la = "ls -a";

      # Safety
      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";

      # Nix shortcuts
      rebuild = "darwin-rebuild switch --flake ~/.config/nix";
      nix-clean = "nix-collect-garbage -d";
    };

    # Init content (runs after zshrc)
    initContent = ''
      # Better history search with up/down arrows
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      # Word navigation with option+arrow
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word
    '';

    # Plugins via home-manager (replaces oh-my-zsh)
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.1.2";
          sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
        };
      }
    ];
  };

  # Install fzf for better fuzzy finding
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # direnv for per-project environments
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
