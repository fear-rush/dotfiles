{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # ===========================================
    # Global Options
    # ===========================================
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Tabs & Indentation
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      smartindent = true;
      autoindent = true;

      # Line wrapping
      wrap = false;

      # Search
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;

      # Appearance
      termguicolors = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      sidescrolloff = 8;

      # Split behavior
      splitright = true;
      splitbelow = true;

      # Undo & Backup
      swapfile = false;
      backup = false;
      undofile = true;

      # Performance
      updatetime = 250;
      timeoutlen = 300;

      # Clipboard
      clipboard = "unnamedplus";

      # Mouse
      mouse = "a";

      # Completion
      completeopt = "menu,menuone,noselect";

      # Concealment (for markdown etc)
      conceallevel = 0;

      # Show whitespace
      list = true;
      listchars = "tab:» ,trail:·,nbsp:␣";
    };

    # ===========================================
    # Colorscheme
    # ===========================================
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        integrations = {
          cmp = true;
          gitsigns = true;
          neo_tree = true;
          telescope = true;
          treesitter = true;
          which_key = true;
          indent_blankline.enabled = true;
          native_lsp.enabled = true;
        };
      };
    };

    # ===========================================
    # Keymaps
    # ===========================================
    keymaps = [
      # General
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear search highlight";
      }
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.desc = "Save file";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<CR>";
        options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>Q";
        action = "<cmd>qa!<CR>";
        options.desc = "Quit all";
      }

      # Better window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Move to left window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Move to bottom window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Move to top window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Move to right window";
      }

      # Resize windows
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<CR>";
        options.desc = "Increase window height";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<CR>";
        options.desc = "Decrease window height";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<CR>";
        options.desc = "Decrease window width";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<CR>";
        options.desc = "Increase window width";
      }

      # Buffer navigation
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<CR>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<CR>";
        options.desc = "Delete buffer";
      }

      # Move lines up/down
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options.desc = "Move line down";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options.desc = "Move line up";
      }

      # Stay in visual mode after indenting
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options.desc = "Indent left";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options.desc = "Indent right";
      }

      # Better paste (don't replace clipboard)
      {
        mode = "v";
        key = "p";
        action = ''"_dP'';
        options.desc = "Paste without yanking";
      }

      # Neo-tree
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle file explorer";
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "<cmd>Neotree focus<CR>";
        options.desc = "Focus file explorer";
      }

      # Telescope
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Find buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<CR>";
        options.desc = "Help tags";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>Telescope oldfiles<CR>";
        options.desc = "Recent files";
      }
      {
        mode = "n";
        key = "<leader>fc";
        action = "<cmd>Telescope commands<CR>";
        options.desc = "Commands";
      }
      {
        mode = "n";
        key = "<leader>fk";
        action = "<cmd>Telescope keymaps<CR>";
        options.desc = "Keymaps";
      }
      {
        mode = "n";
        key = "<leader>/";
        action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
        options.desc = "Search in buffer";
      }

      # Git
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options.desc = "LazyGit";
      }
      {
        mode = "n";
        key = "<leader>gf";
        action = "<cmd>Telescope git_files<CR>";
        options.desc = "Git files";
      }
      {
        mode = "n";
        key = "<leader>gc";
        action = "<cmd>Telescope git_commits<CR>";
        options.desc = "Git commits";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Telescope git_branches<CR>";
        options.desc = "Git branches";
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>Telescope git_status<CR>";
        options.desc = "Git status";
      }

      # LSP
      {
        mode = "n";
        key = "gd";
        action = "<cmd>Telescope lsp_definitions<CR>";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>Telescope lsp_references<CR>";
        options.desc = "Go to references";
      }
      {
        mode = "n";
        key = "gI";
        action = "<cmd>Telescope lsp_implementations<CR>";
        options.desc = "Go to implementation";
      }
      {
        mode = "n";
        key = "gy";
        action = "<cmd>Telescope lsp_type_definitions<CR>";
        options.desc = "Go to type definition";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Hover documentation";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "Code actions";
      }
      {
        mode = "n";
        key = "<leader>cr";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        options.desc = "Rename symbol";
      }
      {
        mode = "n";
        key = "<leader>cf";
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
        options.desc = "Format buffer";
      }
      {
        mode = "n";
        key = "<leader>cd";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Line diagnostics";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Previous diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next diagnostic";
      }

      # Trouble (diagnostics)
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<CR>";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
        options.desc = "Buffer diagnostics";
      }

      # Terminal
      {
        mode = "n";
        key = "<leader>th";
        action = "<cmd>ToggleTerm direction=horizontal<CR>";
        options.desc = "Horizontal terminal";
      }
      {
        mode = "n";
        key = "<leader>tv";
        action = "<cmd>ToggleTerm direction=vertical size=80<CR>";
        options.desc = "Vertical terminal";
      }
      {
        mode = "n";
        key = "<leader>tf";
        action = "<cmd>ToggleTerm direction=float<CR>";
        options.desc = "Float terminal";
      }
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }
    ];

    # ===========================================
    # Plugins
    # ===========================================
    plugins = {
      # Treesitter - Syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          ensure_installed = [
            "bash"
            "css"
            "dockerfile"
            "go"
            "gomod"
            "html"
            "javascript"
            "json"
            "lua"
            "markdown"
            "markdown_inline"
            "nix"
            "php"
            "python"
            "rust"
            "toml"
            "tsx"
            "typescript"
            "vim"
            "vimdoc"
            "yaml"
            "java"
          ];
        };
      };

      # LSP Configuration
      lsp = {
        enable = true;
        servers = {
          # Nix
          nil_ls.enable = true;

          # TypeScript/JavaScript
          ts_ls.enable = true;
          eslint.enable = true;

          # Python
          pyright.enable = true;
          ruff.enable = true;

          # Go
          gopls.enable = true;

          # Rust
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };

          # PHP
          phpactor.enable = true;

          # Java
          jdtls.enable = true;

          # Web
          html.enable = true;
          cssls.enable = true;
          tailwindcss.enable = true;
          jsonls.enable = true;

          # General
          lua_ls.enable = true;
          bashls.enable = true;
          yamlls.enable = true;
          dockerls.enable = true;
        };
      };

      # Completion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
            {name = "luasnip";}
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
          };
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
      };

      # Snippets
      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
        };
      };
      friendly-snippets.enable = true;

      # File explorer
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          window = {
            width = 35;
            mappings = {
              "<space>" = "none";
            };
          };
          filesystem = {
            follow_current_file = {
              enabled = true;
            };
            filtered_items = {
              visible = true;
              hide_dotfiles = false;
              hide_gitignored = false;
            };
          };
        };
      };

      # Statusline
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "catppuccin";
            globalstatus = true;
            component_separators = {
              left = "|";
              right = "|";
            };
            section_separators = {
              left = "";
              right = "";
            };
          };
          sections = {
            lualine_a = ["mode"];
            lualine_b = ["branch" "diff" "diagnostics"];
            lualine_c = ["filename"];
            lualine_x = ["encoding" "fileformat" "filetype"];
            lualine_y = ["progress"];
            lualine_z = ["location"];
          };
        };
      };

      # Bufferline (tabs)
      bufferline = {
        enable = true;
        settings = {
          options = {
            mode = "buffers";
            diagnostics = "nvim_lsp";
            offsets = [
              {
                filetype = "neo-tree";
                text = "File Explorer";
                highlight = "Directory";
                separator = true;
              }
            ];
          };
        };
      };

      # Telescope (fuzzy finder)
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
        settings = {
          defaults = {
            file_ignore_patterns = [
              "node_modules"
              ".git/"
              "target/"
              "dist/"
              ".next/"
            ];
            layout_strategy = "horizontal";
            layout_config = {
              horizontal = {
                preview_width = 0.55;
              };
            };
          };
        };
      };

      # Git signs
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "_";
            topdelete.text = "‾";
            changedelete.text = "~";
          };
          current_line_blame = true;
          current_line_blame_opts = {
            delay = 500;
          };
        };
      };

      # LazyGit integration
      lazygit.enable = true;

      # Which-key (keybinding hints)
      which-key = {
        enable = true;
        settings = {
          spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "Git";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "Code";
            }
            {
              __unkeyed-1 = "<leader>b";
              group = "Buffer";
            }
            {
              __unkeyed-1 = "<leader>t";
              group = "Terminal";
            }
            {
              __unkeyed-1 = "<leader>x";
              group = "Diagnostics";
            }
          ];
        };
      };

      # Autopairs
      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
        };
      };

      # Comment
      comment.enable = true;

      # Surround
      nvim-surround.enable = true;

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          scope = {
            enabled = true;
            show_start = true;
          };
        };
      };

      # Trouble (diagnostics list)
      trouble.enable = true;

      # Todo comments
      todo-comments.enable = true;

      # Terminal
      toggleterm = {
        enable = true;
        settings = {
          open_mapping = "[[<C-\\>]]";
          direction = "float";
          float_opts = {
            border = "curved";
          };
        };
      };

      # Illuminate (highlight word under cursor)
      illuminate.enable = true;

      # Colorizer (show colors inline)
      colorizer.enable = true;

      # Web devicons
      web-devicons.enable = true;

      # Notify (better notifications)
      notify.enable = true;

      # Noice (better UI)
      noice = {
        enable = true;
        settings = {
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
          };
        };
      };

      # Sleuth (auto-detect indent)
      sleuth.enable = true;

      # Markdown preview
      markdown-preview = {
        enable = true;
        settings = {
          auto_close = 0;
          theme = "dark";
        };
      };
    };

    # Extra packages
    extraPackages = with pkgs; [
      # Required for telescope
      ripgrep
      fd

      # Required for LSP
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
    ];
  };
}
