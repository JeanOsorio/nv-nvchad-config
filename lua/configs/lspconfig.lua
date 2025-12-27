-- Cargar configuración por defecto de NvChad
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

-- Resolver ruta a gopls si está instalada con gvm
local function resolve_gopls()
  local exepath = vim.fn.exepath "gopls"
  if exepath ~= "" then
    return exepath
  end

  local uv = vim.loop
  local home = uv.os_homedir()
  local pkgsets_root = home .. "/.gvm/pkgsets"
  local handle = uv.fs_scandir(pkgsets_root)

  if handle then
    while true do
      local name, typ = uv.fs_scandir_next(handle)
      if not name then
        break
      end

      if typ == "directory" then
        local base = pkgsets_root .. "/" .. name
        for _, flavor in ipairs { "global", "local" } do
          local candidate = string.format("%s/%s/bin/gopls", base, flavor)
          if vim.fn.filereadable(candidate) == 1 then
            return candidate
          end
        end
      end
    end
  end

  local gvm_bin = home .. "/.gvm/bin/gopls"
  if vim.fn.filereadable(gvm_bin) == 1 then
    return gvm_bin
  end

  return nil
end

-- Tabla de configuración por servidor
local servers = {
  html = {
    cmd = { "vscode-html-language-server", "--stdio" },
  },
  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
  },
  tsserver = {
    cmd = { "typescript-language-server", "--stdio" },
    settings = {
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
    },
  },
  clangd = {
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = vim.fs.dirname(
      vim.fs.find({ "compile_commands.json", "compile_flags.txt", ".git" }, { upward = true })[1]
    ),
  },
  gopls = (function()
    local gopls_cmd = resolve_gopls()
    if not gopls_cmd then
      vim.schedule(function()
        vim.notify("gopls no encontrado; instala via gvm (gvm get) o agrega su ruta al PATH", vim.log.levels.WARN)
      end)
      return nil
    end
    return {
      cmd = { gopls_cmd },
      settings = {
        gopls = {
          gofumpt = true,
          analyses = {
            unusedparams = true,
            unreachable = true,
          },
          staticcheck = true,
        },
      },
    }
  end)(),
}

-- Configurar LSP con nueva API sin usar require("lspconfig")
for name, config in pairs(servers) do
  if config then
    vim.lsp.config[name] = vim.tbl_deep_extend("force", config, {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    })
    vim.lsp.start(vim.lsp.config[name])
  end
end
-- -- load defaults i.e lua_lsp
-- require("nvchad.configs.lspconfig").defaults()
--
-- local lspconfig = require "lspconfig"
--
-- -- EXAMPLE
-- local servers = { "html", "cssls", "ts_ls", "clangd", "gopls" }
-- local nvlsp = require "nvchad.configs.lspconfig"
--
-- local function resolve_gopls()
--   -- Try current PATH first
--   local exepath = vim.fn.exepath "gopls"
--   if exepath ~= "" then
--     return exepath
--   end
--
--   -- Fallback: scan gvm pkgsets without hardcoding a Go version
--   local uv = vim.loop
--   local home = uv.os_homedir()
--   local pkgsets_root = home .. "/.gvm/pkgsets"
--   local handle = uv.fs_scandir(pkgsets_root)
--
--   if handle then
--     while true do
--       local name, typ = uv.fs_scandir_next(handle)
--       if not name then
--         break
--       end
--
--       if typ == "directory" then
--         local base = pkgsets_root .. "/" .. name
--         for _, flavor in ipairs { "global", "local" } do
--           local candidate = string.format("%s/%s/bin/gopls", base, flavor)
--           if vim.fn.filereadable(candidate) == 1 then
--             return candidate
--           end
--         end
--       end
--     end
--   end
--
--   local gvm_bin = home .. "/.gvm/bin/gopls"
--   if vim.fn.filereadable(gvm_bin) == 1 then
--     return gvm_bin
--   end
--
--   return nil
-- end
--
-- -- lsps with default config
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = nvlsp.on_attach,
--     on_init = nvlsp.on_init,
--     capabilities = nvlsp.capabilities,
--   }
-- end
--
-- for _, lsp in ipairs(servers) do
--   local opts = {
--     on_attach = nvlsp.on_attach,
--     on_init = nvlsp.on_init,
--     capabilities = nvlsp.capabilities,
--   }
--
--   if lsp == "ts_ls" then
--     opts.settings = {
--       javascript = {
--         validate = { enable = true },
--         suggest = {
--           autoImports = true,
--           includeAutomaticOptionalChainCompletions = true,
--         },
--         format = { semicolons = "insert" },
--         checkJs = true,
--       },
--       typescript = {
--         validate = { enable = true },
--         format = { semicolons = "insert" },
--       },
--     }
--   elseif lsp == "clangd" then
--     opts.cmd = { "clangd", "--background-index" }
--     opts.filetypes = { "c", "cpp", "objc", "objcpp" }
--     opts.root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
--   elseif lsp == "gopls" then
--     local gopls_cmd = resolve_gopls()
--     if gopls_cmd then
--       opts.cmd = { gopls_cmd }
--     else
--       vim.schedule(function()
--         vim.notify("gopls no encontrado; instala via gvm (gvm get) o agrega su ruta al PATH", vim.log.levels.WARN)
--       end)
--     end
--
--     opts.settings = {
--       gopls = {
--         gofumpt = true,
--         analyses = { unusedparams = true, unreachable = true },
--         staticcheck = true,
--       },
--     }
--   end
--
--   lspconfig[lsp].setup(opts)
-- end
--
