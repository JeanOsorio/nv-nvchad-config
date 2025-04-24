-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "ts_ls", "clangd" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

for _, lsp in ipairs(servers) do
  local opts = {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }

  if lsp == "ts_ls" then
    opts.settings = {
      javascript = {
        validate = { enable = true },
        suggest = {
          autoImports = true,
          includeAutomaticOptionalChainCompletions = true,
        },
        format = { semicolons = "insert" },
        checkJs = true,
      },
      typescript = {
        validate = { enable = true },
        format = { semicolons = "insert" },
      },
    }
  elseif lsp == "clangd" then
    opts.cmd = { "clangd", "--background-index" }
    opts.filetypes = { "c", "cpp", "objc", "objcpp" }
    opts.root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
  end

  lspconfig[lsp].setup(opts)
  -- lspconfig[lsp].setup {
  --   on_attach = nvlsp.on_attach,
  --   on_init = nvlsp.on_init,
  --   capabilities = nvlsp.capabilities,
  --   settings = (lsp == "ts_ls")
  --       and {
  --         javascript = {
  --           validate = {
  --             enable = true, -- Habilita la validación para JS
  --           },
  --           suggest = {
  --             autoImports = true, -- Activa las auto-importaciones
  --             includeAutomaticOptionalChainCompletions = true,
  --           },
  --           format = {
  --             semicolons = "insert",
  --           },
  --           checkJs = true, -- Habilita la verificación de errores en JS
  --         },
  --         typescript = {
  --           validate = {
  --             enable = true,
  --           },
  --           format = {
  --             semicolons = "insert",
  --           },
  --         },
  --       }
  --     or (lsp == "clangd") and {
  --       cmd = { "clangd", "--background-index" },
  --       filetypes = { "c", "cpp", "objc", "objcpp" },
  --       root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
  --     }
  --     or nil, -- Solo aplica settings si es ts_ls
  -- }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
