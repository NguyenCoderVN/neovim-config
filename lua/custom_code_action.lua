local M = {}

function M.run_uppercase()
  local word = vim.fn.expand("<cword>")
  if not word or word == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN)
    return
  end
  local upper = string.upper(word)

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  local s, e = line:find(word, 1, true)
  if s and e then
    local new_line = line:sub(1, s - 1) .. upper .. line:sub(e + 1)
    vim.api.nvim_set_current_line(new_line)
    vim.notify("Converted '" .. word .. "' → '" .. upper .. "'")
  end
end

return M
