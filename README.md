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

## Nix Cheat Sheet for Beginners

### Core Concepts

| Concept | Description |
|---------|-------------|
| **Flake** | A self-contained Nix project with `flake.nix` and `flake.lock` |
| **Derivation** | A build recipe that produces packages in `/nix/store` |
| **Generation** | A snapshot of your system configuration (enables rollback) |
| **Channel** | Legacy package source (we use flakes instead) |
| **nixpkgs** | The main repository of ~100,000+ Nix packages |

### Daily Commands (Most Used)

```bash
# Apply your configuration changes (use after editing .nix files)
rebuild                    # alias defined in zsh config
# or full command:
sudo darwin-rebuild switch --flake ~/.config/nix

# Preview changes without applying (dry run)
darwin-rebuild build --flake ~/.config/nix

# Update all packages to latest versions
cd ~/.config/nix && nix flake update && rebuild

# Clean up disk space (remove old generations)
nix-clean                  # alias defined in zsh config
# or full command:
nix-collect-garbage -d
```

### System Management

```bash
# List all system generations (history of configurations)
darwin-rebuild --list-generations

# Roll back to previous generation
sudo darwin-rebuild --rollback

# Switch to specific generation number
sudo darwin-rebuild switch --generation 42

# See current system info
darwin-rebuild --show-trace

# Check which generation is active
ls -la /run/current-system
```

### Package Management

```bash
# Search for packages (online)
nix search nixpkgs <package-name>
nix search nixpkgs nodejs
nix search nixpkgs "python.*"

# Show package info
nix-env -qaP --description <package-name>

# Try a package temporarily (doesn't install permanently)
nix shell nixpkgs#cowsay
nix shell nixpkgs#nodejs_22

# Run a command from a package without installing
nix run nixpkgs#cowsay -- "Hello Nix!"

# List installed packages (user profile)
nix profile list

# See what's in the store
nix path-info -rsSh /run/current-system | sort -k2 -h | tail -20
```

### Flake Commands

```bash
# Show flake info
nix flake show

# Check flake for errors
nix flake check

# Update all inputs (nixpkgs, home-manager, etc.)
nix flake update

# Update specific input only
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager

# Show current input versions
nix flake metadata

# Format all .nix files
nix fmt
```

### Development Environments

```bash
# Enter a dev shell defined in flake.nix
nix develop

# Enter dev shell with specific packages
nix develop --impure --expr 'with import <nixpkgs> {}; mkShell { packages = [ nodejs python3 ]; }'

# Use direnv for auto-activation (already configured)
# Just cd into a directory with .envrc containing: use flake
echo "use flake" > .envrc
direnv allow
```

### Debugging & Troubleshooting

```bash
# Build with verbose output
darwin-rebuild build --flake ~/.config/nix --show-trace

# Check why a package is in your closure
nix why-depends /run/current-system nixpkgs#<package>

# Visualize dependencies
nix-tree /run/current-system

# Check store path size
nix path-info -sSh /run/current-system

# Verify store integrity
nix store verify --all

# Repair broken store paths
sudo nix store repair --all
```

### Garbage Collection

```bash
# Remove all old generations (keeps current)
nix-collect-garbage -d

# Remove generations older than 30 days
nix-collect-garbage --delete-older-than 30d

# Just list what would be deleted
nix-collect-garbage -d --dry-run

# Optimize store (deduplicate files)
nix store optimise
```

### Useful Paths

| Path | Description |
|------|-------------|
| `~/.config/nix/` | Your Nix configuration (this repo) |
| `/nix/store/` | All packages (immutable, content-addressed) |
| `/run/current-system/` | Symlink to current system generation |
| `/etc/profiles/per-user/$USER/` | User packages from Nix |
| `~/.nix-profile/` | User profile symlinks |

### Quick Edits

| Task | File to Edit |
|------|--------------|
| Add CLI tool | `modules/shared/packages.nix` |
| Add GUI app (Homebrew cask) | `modules/darwin/homebrew.nix` |
| Modify shell aliases | `modules/home/shell/zsh.nix` |
| Change macOS settings | `modules/darwin/system.nix` |
| Modify Git config | `modules/home/shell/git.nix` |
| Add Node.js packages | `modules/home/dev/node.nix` |
| Add Python packages | `modules/home/dev/python.nix` |

### Workflow Example

```bash
# 1. Edit configuration
vim ~/.config/nix/modules/shared/packages.nix

# 2. Test build (catches errors without applying)
darwin-rebuild build --flake ~/.config/nix

# 3. Apply changes
rebuild   # or: sudo darwin-rebuild switch --flake ~/.config/nix

# 4. Open new terminal to get updated PATH

# 5. Commit your changes
cd ~/.config/nix && git add -A && git commit -m "Add new package"
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

### Development Languages & Tools

| Language | Version | Package Manager | Tools |
|----------|---------|-----------------|-------|
| Node.js | 22 LTS | pnpm, bun, npm | typescript, prettier, ncu |
| Python | 3.13 | uv | ruff (linter/formatter) |
| Go | latest | go modules | gopls, golangci-lint, delve |
| Rust | via rustup | cargo | cargo-watch, cargo-edit, cargo-nextest, cargo-audit |
| PHP | 8.3 | composer | phpstan, php-cs-fixer |
| Java | 21 (Temurin) | maven, gradle | jdt-language-server |

**Note**: For Rust, after rebuild run `rustup default stable` to install the default toolchain.

### Neovim Keybindings (Nixvim)

Leader key is `<Space>`. Press it and wait for which-key popup.

| Key | Action |
|-----|--------|
| **General** | |
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>e` | Toggle file explorer (neo-tree) |
| `<Esc>` | Clear search highlight |
| **Find (Telescope)** | |
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep (search text) |
| `<Space>fb` | Find buffers |
| `<Space>fr` | Recent files |
| `<Space>/` | Search in current buffer |
| **Git** | |
| `<Space>gg` | Open LazyGit |
| `<Space>gs` | Git status |
| `<Space>gc` | Git commits |
| `<Space>gb` | Git branches |
| **Code (LSP)** | |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<Space>ca` | Code actions |
| `<Space>cr` | Rename symbol |
| `<Space>cf` | Format buffer |
| `[d` / `]d` | Previous/next diagnostic |
| **Buffers** | |
| `<S-h>` / `<S-l>` | Previous/next buffer |
| `<Space>bd` | Delete buffer |
| **Windows** | |
| `<C-h/j/k/l>` | Navigate windows |
| `<C-Up/Down/Left/Right>` | Resize windows |
| **Terminal** | |
| `<C-\>` | Toggle floating terminal |
| `<Space>th` | Horizontal terminal |
| `<Space>tv` | Vertical terminal |
| `<Esc><Esc>` | Exit terminal mode |

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

### Phase 2: Development Tools (COMPLETED)

- [x] Node.js 22 LTS (replaces nvm)
- [x] Bun
- [x] pnpm
- [x] Python 3.13 + uv + ruff
- [x] Go + gopls + golangci-lint + delve
- [x] Rust via rustup + cargo tools
- [x] PHP 8.3 + Composer + phpstan + php-cs-fixer
- [x] Java 21 (Temurin) + Maven + Gradle (replaces sdkman)
- [x] Common dev tools (hyperfine, sd, procs, dust, duf)

### Phase 3: Editor - Nixvim (COMPLETED)

- [x] Base Nixvim setup with Catppuccin theme
- [x] LSP for: Nix, TypeScript, Python, Go, Rust, PHP, Java, HTML/CSS, JSON, YAML, Bash, Docker
- [x] Completion (nvim-cmp + luasnip + friendly-snippets)
- [x] UI (neo-tree, lualine, bufferline, noice, notify)
- [x] Navigation (telescope + fzf-native)
- [x] Git integration (gitsigns, lazygit)
- [x] Quality of life (which-key, autopairs, surround, comment, todo-comments, trouble)
- [x] Treesitter syntax highlighting
- [x] Terminal integration (toggleterm)

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

## Tools Migrated from Legacy Installation

These tools have been migrated from their legacy locations to Nix:

| Tool | Old Location | Now Managed By |
|------|--------------|----------------|
| nvm | `~/.nvm` | Nix nodejs_22 |
| sdkman | `~/.sdkman` | Nix temurin-bin-21 |
| Bun | `~/.bun` | Nix bun |
| pnpm | `~/Library/pnpm` | Nix pnpm |

**Cleanup**: You can now remove the legacy directories after verifying everything works:
```bash
rm -rf ~/.nvm ~/.sdkman ~/.bun ~/Library/pnpm
```

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
