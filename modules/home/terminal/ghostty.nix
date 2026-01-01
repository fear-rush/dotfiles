{
  inputs,
  pkgs,
  ...
}: {
  # Ghostty configuration managed by home-manager
  # The application itself is installed via Homebrew cask

  home.file.".config/ghostty/config".text = ''
    # Theme
    theme = TokyoNight Moon

    # Font settings
    font-family = Hack Nerd Font
    font-size = 14

    # Window settings
    window-padding-x = 10
    window-padding-y = 10
    window-decoration = true

    # Cursor
    cursor-style = block
    cursor-style-blink = true

    # Shell integration
    shell-integration = zsh

    # macOS specific
    macos-option-as-alt = true
    macos-titlebar-style = hidden

    # Performance
    gtk-single-instance = true

    # Keybindings (examples)
    # keybind = super+t=new_tab
    # keybind = super+w=close_surface
    # keybind = super+shift+enter=new_split:right
    # keybind = super+enter=new_split:down
  '';

  # Ensure Nerd Fonts are available
  # In nixpkgs-unstable, nerdfonts is now nerd-fonts with individual packages
  home.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
