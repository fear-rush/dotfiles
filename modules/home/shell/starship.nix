{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Prompt format
      format = ''
        $directory$git_branch$git_status$fill$all$line_break$character
      '';

      # Right prompt (shows time)
      right_format = ''
        $time
      '';

      # Character (prompt symbol)
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
        vimcmd_symbol = "[<](bold green)";
      };

      # Directory
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      # Git branch
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = " ";
        style = "bold purple";
      };

      # Git status
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
      };

      # Fill - adds space between left and right
      fill = {
        symbol = " ";
      };

      # Time (shown on right)
      time = {
        disabled = false;
        format = "[$time]($style) ";
        style = "dimmed white";
        time_format = "%H:%M";
      };

      # Language formats - only show when project uses that language
      # (Preserved from your existing config)
      buf.format = "(with [$symbol$version ]($style))";
      bun.format = "(via [$symbol($version )]($style))";
      c.format = "(via [$symbol($version(-$name) )]($style))";
      cmake.format = "(via [$symbol($version )]($style))";
      crystal.format = "(via [$symbol($version )]($style))";
      dart.format = "(via [$symbol($version )]($style))";
      deno.format = "(via [$symbol($version )]($style))";
      elixir.format = "(via [$symbol($version (OTP $otp_version) )]($style))";
      elm.format = "(via [$symbol($version )]($style))";
      erlang.format = "(via [$symbol($version )]($style))";
      golang.format = "(via [$symbol($version )]($style))";
      haskell.format = "(via [$symbol($version )]($style))";
      helm.format = "(via [$symbol($version )]($style))";
      java.format = "(via [$symbol($version )]($style))";
      julia.format = "(via [$symbol($version )]($style))";
      kotlin.format = "(via [$symbol($version )]($style))";
      lua.format = "(via [$symbol($version )]($style))";
      nim.format = "(via [$symbol($version )]($style))";
      nodejs.format = "(via [$symbol($version )]($style))";
      ocaml.format = "(via [$symbol($version )(($switch_indicator$switch_name) )]($style))";
      package.format = "(is [$symbol$version]($style) )";
      perl.format = "(via [$symbol($version )]($style))";
      php.format = "(via [$symbol($version )]($style))";
      python.format = "(via [$symbol$pyenv_prefix($version )(($virtualenv) )]($style))";
      ruby.format = "(via [$symbol($version )]($style))";
      rust.format = "(via [$symbol($version )]($style))";
      scala.format = "(via [$symbol($version )]($style))";
      swift.format = "(via [$symbol($version )]($style))";
      zig.format = "(via [$symbol($version )]($style))";

      # Nix shell indicator
      nix_shell = {
        format = "via [$symbol$state( ($name))]($style) ";
        symbol = " ";
        style = "bold blue";
      };

      # Docker context
      docker_context = {
        format = "via [$symbol$context]($style) ";
        symbol = " ";
        style = "bold blue";
      };

      # Kubernetes
      kubernetes = {
        disabled = false;
        format = "[$symbol$context( ($namespace))]($style) ";
        symbol = "󱃾 ";
        style = "bold blue";
      };

      # AWS
      aws = {
        format = "on [$symbol($profile )(($region) )]($style)";
        symbol = " ";
        style = "bold yellow";
      };
    };
  };
}
