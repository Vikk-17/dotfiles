return {
    {
        "stevearc/conform.nvim",
        -- event = 'BufWritePre', -- uncomment for format on save
        opts = require "configs.conform",
    },

    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        }
    },
    {
        "mason-org/mason.nvim",
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^6',
        lazy = false,   -- This plugin must not be lazy loaded
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    cmd = function()
                        local ra_binary = vim.fn.exepath("rust-analyzer")
                        return { "bash", "-c", "RAYON_NUM_THREADS=4 " .. ra_binary }
                    end,
                    default_settings = {
                        -- rust-analyzer language server configuration
                        ['rust-analyzer'] = {
                            -- OPTIMIZATION 1: Limit cache usage
                            lru = {
                                capacity = 32,
                            },
                            -- OPTIMIZATION 2: Disable initial full project scan
                            cachePriming = {
                                enable = false,
                            },
                            -- OPTIMIZATION 3: Disable procMacros (Saves massive RAM, but disables some autocompletes)
                            procMacro = {
                                enable = false,
                            },
                            cargo = {
                                -- OPTIMIZATION 4: Do NOT use allFeatures (High RAM usage)
                                allFeatures = false,
                                buildScripts = {
                                    enable = false,
                                },
                            },
                            checkOnSave = {
                                -- command = "clippy",
                                enable = false,
                            },
                            diagnostics = {
                                enable = true, -- I suggest keeping this true, or LSP is useless
                            },
                            imports = {
                                granularity = {
                                    group = "module",
                                },
                                prefix = "self",
                            },
                            files = {
                                excludeDirs = {
                                    ".git",
                                    ".cargo",
                                    "target",
                                    "node_modules",
                                    "dist",
                                    "build"
                                },
                            },
                        },
                    },
                },
            }
        end
    },
  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
