-- Carga la configuración base de NvChad
local default_config = require("nvchad.configs.nvimtree")

-- Configuración extendida para nvim-tree
local custom_config = {
  git = {
    enable = true,
    ignore = false,
  },
  view = {
    side = "right",
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

-- Combina las configuraciones sin sobrescribir la base
local final_config = vim.tbl_deep_extend("force", default_config, custom_config)

return final_config

