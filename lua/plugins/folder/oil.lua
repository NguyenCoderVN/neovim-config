return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- use this or mini.icons for file icons
  },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  -- config = function()
  --   vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open parent directory" })
  -- end,
}
