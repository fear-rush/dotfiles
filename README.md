# Firas's Nix Configuration

A declarative, reproducible system configuration for macOS using [Nix](https://nixos.org/), [nix-darwin](https://github.com/LnL7/nix-darwin), and [home-manager](https://github.com/nix-community/home-manager).

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Your macOS System (maryln)                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                     Determinate Nix (Package Manager)               │   │
│  │  • Manages /nix/store (all packages)                                │   │
│  │  • Provides nix CLI commands                                        │   │
│  │  • Runs nix-daemon for multi-user support                           │   │
│  │  • Flakes enabled by default                                        │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                         nix-darwin                                  │   │
│  │  • System-level macOS configuration                                 │   │
│  │  • Manages /etc files                                               │   │
│  │  • Controls macOS defaults (Dock, Finder, etc.)                     │   │
│  │  • Homebrew cask management                                         │   │
│  │  • LaunchDaemons/LaunchAgents                                       │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                       home-manager                                  │   │
│  │  • User-level environment configuration                             │   │
│  │  • Dotfiles management (~/.config/*, ~/.zshrc, etc.)                │   │
│  │  • User packages (CLI tools, applications)                          │   │
│  │  • Shell configuration (zsh, starship)                              │   │
│  │  • Program configurations (git, ssh, lazygit, etc.)                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    Homebrew (Managed by nix-darwin)                 │   │
│  │  • GUI Applications only (casks)                                    │   │
│  │  • Chrome, Zed, OrbStack, Ghostty                                   │   │
│  │  • Declaratively managed via Nix configuration                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## How It Works

```
~/.config/nix/flake.nix
         │
         ▼
    ┌─────────────────┐
    │   nix build     │
    │   (evaluation)  │
    └────────┬────────┘
             │
             ▼
    ┌─────────────────┐
    │  /nix/store/... │ ◄── Immutable, content-addressed
    │  (derivations)  │     packages stored here
    └────────┬────────┘
             │
             ▼
    ┌─────────────────┐
    │ darwin-rebuild  │
    │    switch       │
    └────────┬────────┘
             │
             ├──────────────┬──────────────┬──────────────┐
             ▼              ▼              ▼              ▼
    ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
    │  /etc/*     │ │ ~/.config/* │ │ ~/.*rc      │ │  Homebrew   │
    │  (system)   │ │  (dotfiles) │ │  (shell)    │ │   (casks)   │
    └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘
```

## Project Structure

```
~/.config/nix/
├── flake.nix                    # Main entry point - inputs & outputs
├── flake.lock                   # Locked versions of all dependencies
├── README.md                    # This file
│
├── hosts/                       # Machine-specific configurations
│   └── maryln/                  # Your Mac (Apple Silicon, Sonoma)
│       └── default.nix          # nix-darwin system configuration
│
├── modules/                     # Reusable configuration modules
│   ├── darwin/                  # macOS-specific modules
│   │   ├── system.nix           # macOS system preferences (Dock, Finder, etc.)
│   │   └── homebrew.nix         # Homebrew casks management
│   │
│   ├── home/                    # User environment modules
│   │   ├── shell/               # Shell configuration
│   │   │   ├── zsh.nix          # Zsh + plugins + aliases
│   │   │   ├── starship.nix     # Starship prompt configuration
│   │   │   └── git.nix          # Git + SSH + GitHub CLI + Lazygit
│   │   │
│   │   ├── terminal/            # Terminal emulators
│   │   │   └── ghostty.nix      # Ghostty configuration
│   │   │
│   │   ├── editors/             # Text editors (Phase 3)
│   │   │   └── nixvim/          # Neovim via nixvim
│   │   │
│   │   └── dev/                 # Development tools (Phase 2)
│   │       ├── node.nix         # Node.js + Bun
│   │       ├── python.nix       # Python + uv
│   │       └── ...              # Go, Rust, PHP, Java
│   │
│   └── shared/                  # Cross-platform modules
│       └── packages.nix         # Common CLI tools
│
├── users/                       # User configurations
│   └── firas/
│       └── default.nix          # User-specific home-manager config
│
├── secrets/                     # SOPS encrypted secrets (Phase 4)
│   ├── secrets.yaml             # Encrypted secrets
│   └── .sops.yaml               # SOPS configuration
│
└── lib/                         # Helper functions
    └── overlays.nix             # Nixpkgs overlays
```

## Quick Reference

### Essential Commands

```bash
# Rebuild and switch to new configuration
rebuild
# or full command:
darwin-rebuild switch --flake ~/.config/nix

# Update all flake inputs (nixpkgs, home-manager, etc.)
cd ~/.config/nix && nix flake update

# Update specific input
cd ~/.config/nix && nix flake lock --update-input nixpkgs

# Clean up old generations (free disk space)
nix-clean
# or full command:
nix-collect-garbage -d

# Show what would change without applying
darwin-rebuild build --flake ~/.config/nix

# Roll back to previous generation
darwin-rebuild --rollback

# List all generations
darwin-rebuild --list-generations

# Search for packages
nix search nixpkgs <package-name>
```

### Git Aliases (from zsh config)

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Short for git |
| `gst` | `git status` | Show status |
| `ga` | `git add` | Add files |
| `gaa` | `git add --all` | Add all files |
| `gc` | `git commit -v` | Commit verbose |
| `gcmsg` | `git commit -m` | Commit with message |
| `gco` | `git checkout` | Checkout |
| `gcb` | `git checkout -b` | Create & checkout branch |
| `gd` | `git diff` | Show diff |
| `gds` | `git diff --staged` | Show staged diff |
| `gl` | `git pull` | Pull |
| `gp` | `git push` | Push |
| `gpf` | `git push --force-with-lease` | Safe force push |
| `glog` | `git log --oneline --decorate --graph` | Pretty log |
| `gsta` | `git stash push` | Stash changes |
| `gstp` | `git stash pop` | Pop stash |
| `grb` | `git rebase` | Rebase |
| `grbi` | `git rebase -i` | Interactive rebase |

### Directory Navigation

| Alias | Description |
|-------|-------------|
| `..` | Go up one directory |
| `...` | Go up two directories |
| `....` | Go up three directories |
| `z <dir>` | Smart directory jump (zoxide) |

### Modern CLI Tools Installed

| Tool | Replaces | Description |
|------|----------|-------------|
| `eza` | `ls` | Modern ls with colors and icons |
| `bat` | `cat` | Cat with syntax highlighting |
| `fd` | `find` | User-friendly find alternative |
| `rg` (ripgrep) | `grep` | Fast recursive grep |
| `fzf` | - | Fuzzy finder (Ctrl+R for history) |
| `lazygit` | - | Terminal UI for git |
| `delta` | - | Syntax-highlighting diff pager |
| `bottom` | `htop` | System monitor (run with `btm`) |
| `jq` | - | JSON processor |
| `yq` | - | YAML processor |
| `just` | `make` | Command runner |

## What's Managed by Nix

### System Level (nix-darwin)

- [x] macOS system defaults (Dock, Finder, keyboard, trackpad)
- [x] Touch ID for sudo
- [x] Homebrew casks (declarative GUI app management)
- [x] System packages in `/run/current-system/sw/bin`
- [x] `/etc/zshenv` (shell initialization)

### User Level (home-manager)

- [x] Shell configuration (zsh)
- [x] Prompt (starship)
- [x] Git configuration + SSH
- [x] GitHub CLI
- [x] Lazygit
- [x] Terminal configuration (Ghostty)
- [x] CLI tools (see above)
- [x] Fonts (Hack, JetBrains Mono, Fira Code - Nerd Fonts)

### Homebrew Casks (GUI Apps)

- [x] Google Chrome
- [x] Zed (editor)
- [x] OrbStack (Docker/Linux VMs)
- [x] Ghostty (terminal)

## Migration Progress

### Phase 1: Foundation (COMPLETED)

- [x] Install Determinate Nix
- [x] Create flake.nix with inputs
- [x] Set up nix-darwin for maryln
- [x] Integrate home-manager
- [x] Migrate zsh (replaces oh-my-zsh)
- [x] Migrate starship prompt
- [x] Migrate Ghostty configuration
- [x] Migrate Git + SSH for GitHub
- [x] First successful darwin-rebuild switch

### Phase 2: Development Tools (PENDING)

- [ ] Node.js 22 LTS (replaces nvm)
- [ ] Bun
- [ ] Python + uv (uv managed by Nix)
- [ ] Go
- [ ] Rust via rustup/fenix
- [ ] PHP
- [ ] Java 21 (replaces sdkman)
- [ ] Common dev tools

### Phase 3: Editor - Nixvim (PENDING)

- [ ] Base Nixvim setup
- [ ] LSP configuration (all languages)
- [ ] Completion (blink.cmp)
- [ ] UI (neo-tree, lualine, bufferline)
- [ ] Navigation (telescope)
- [ ] Git integration (gitsigns, lazygit)
- [ ] Quality of life (which-key, autopairs)

### Phase 4: Applications & Secrets (PENDING)

- [ ] More Homebrew casks
- [ ] SOPS-nix for secrets
- [ ] More macOS defaults

### Phase 5: Cleanup (PENDING)

- [ ] Remove oh-my-zsh (~/.oh-my-zsh)
- [ ] Remove nvm (~/.nvm)
- [ ] Remove sdkman (~/.sdkman)
- [ ] Clean up Homebrew
- [ ] Push to GitHub

## Backed Up Files

Your original dotfiles were preserved with `.backup` extension:

| Original | Backup |
|----------|--------|
| `~/.zshrc` | `~/.zshrc.backup` |
| `~/.zshenv` | `~/.zshenv.backup` |
| `~/.config/starship.toml` | `~/.config/starship.toml.backup` |
| `~/.config/ghostty/config` | `~/.config/ghostty/config.backup` |
| `~/.config/gh/config.yml` | `~/.config/gh/config.yml.backup` |
| `~/.ssh/config` | `~/.ssh/config.backup` |

## Tools Still Using Legacy Installation

These tools are still sourced from their original locations (will be migrated in Phase 2):

| Tool | Current Location | Will Migrate To |
|------|------------------|-----------------|
| nvm | `~/.nvm` | Nix nodejs |
| sdkman | `~/.sdkman` | Nix jdk |
| Bun | `~/.bun` | Nix bun |
| pnpm | `~/Library/pnpm` | Nix pnpm |

## Troubleshooting

### Shell not loading properly

Close and reopen your terminal. The new shell configuration requires a fresh login shell.

### Command not found after rebuild

Run `hash -r` to clear the command hash table, or open a new terminal.

### Homebrew cask fails to install

```bash
# Check if the app is already installed manually
ls /Applications/

# If conflicts, manually remove and retry
sudo rm -rf /Applications/AppName.app
rebuild
```

### Rollback to previous configuration

```bash
# List generations
darwin-rebuild --list-generations

# Rollback to previous
darwin-rebuild --rollback
```

### Nix store taking too much space

```bash
# Remove old generations
nix-collect-garbage -d

# Optimize store (deduplicate)
nix store optimise
```

### Check what a file is symlinked to

```bash
ls -la ~/.zshrc
# Should show -> /nix/store/xxx-home-manager-files/.zshrc
```

## Adding New Packages

### CLI tools (via Nix)

Edit `modules/shared/packages.nix`:

```nix
home.packages = with pkgs; [
  # Add new package here
  neofetch
];
```

### GUI applications (via Homebrew casks)

Edit `modules/darwin/homebrew.nix`:

```nix
casks = [
  # Add new cask here
  "spotify"
];
```

Then rebuild:

```bash
rebuild
```

## Adding a New Machine

1. Create `hosts/<hostname>/default.nix`
2. Add to `flake.nix`:

```nix
darwinConfigurations = {
  maryln = mkDarwinHost "maryln" { system = systems.darwin; };
  # Add new machine:
  newmachine = mkDarwinHost "newmachine" { system = systems.darwin; };
};
```

## Resources

- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/index.html)
- [home-manager Manual](https://nix-community.github.io/home-manager/)
- [Nixpkgs Search](https://search.nixos.org/packages)
- [Zero to Nix](https://zero-to-nix.com/)
- [r17x/universe](https://github.com/r17x/universe) - Inspiration for structure

## License

MIT
