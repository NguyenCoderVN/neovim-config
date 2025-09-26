vim.keymap.set("n", "<C-p>", ":Oil<CR>", { desc = "Open Oil" })

vim.keymap.set({ "n", "v", "i" }, "<C-q>", "<Esc>:wqa<CR>")
vim.keymap.set({ "n", "v", "i" }, "<C-s>", "<Esc>:wa<CR>")

vim.keymap.set("n", "<leader>sr", ":source %<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      timeout = 2000, -- in milliseconds
    })
  end,
})
