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
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    settings = (lsp == "ts_ls")
        and {
          javascript = {
            validate = {
              enable = true, -- Habilita la validación para JS
            },
            suggest = {
              autoImports = true, -- Activa las auto-importaciones
              includeAutomaticOptionalChainCompletions = true,
            },
            format = {
              semicolons = "insert",
            },
            checkJs = true, -- Habilita la verificación de errores en JS
          },
          typescript = {
            validate = {
              enable = true,
            },
            format = {
              semicolons = "insert",
            },
          },
        }
      or nil, -- Solo aplica settings si es ts_ls
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
