return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")

    --
    -- local lspconfig_defaults = lspconfig.util.default_config
    -- lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    --   "force",
    --   lspconfig_defaults.capabilities,
    --   require("cmp_nvim_lsp").default_capabilities()
    -- )
    --
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    --
    -- lspconfig.solargraph.setup {
    --   cmd = { "/opt/homebrew/opt/rbenv/shims/solargraph", "stdio" },
    --   autoformat = true,
    --   capabilities = capabilities
    -- }

    lspconfig.ruby_lsp.setup({
      cmd = { "/opt/homebrew/opt/rbenv/shims/ruby-lsp" },
      formatter = "rubocop_internal",
      init_options = {
        formatter = "rubocop_internal",
        linters = { "rubocop" }
      },
      capabilities = capabilities
    })

    lspconfig.eslint.setup {}
    lspconfig.html.setup {}
    lspconfig.cssls.setup {}
    -- lspconfig.rust_analyzer.setup {
    --   capabilities = capabilities
    -- }

    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
          return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            -- version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        })
      end,
      settings = {
        Lua = {
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
              quote_style = "double",
              trailing_table_separator = "never"
            }
          }
        }
      }
    }
  end
}
