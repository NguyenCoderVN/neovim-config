return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "vimls",
        "pyright",
        "pylsp",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- format
        "stylua",
        "black",
        "isort",
        "prettier",

        -- lint
        "luacheck",
        "pylint",
      },
    },
  },
}
