local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettierd", "prettier" },
    javascriptreact = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    typescriptreact = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    html = { "prettierd", "prettier" },
    json = { "prettierd", "prettier" },
    jsonc = { "prettierd", "prettier" },
    solidity = { "prettierd", "prettier" },
    markdown = { "deno_fmt" },
  },

  format_on_save = {
    -- these options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options

