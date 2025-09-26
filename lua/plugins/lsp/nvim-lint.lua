return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    -- if os.getenv("VIRTUAL_ENV") then
    --   lint.linters.pylint.args = { "--load-plugins=pylint_venv" }
    -- end

    -- lint.linters.pylint.args = {
    --   "--output-format=text",
    --   "--score=no",
    --   "%:p",
    -- }

    lint.linters.pylint = {
      cmd = "pylint",
      stdin = false,
      args = {
        "--output-format=text",
        "--score=no",
        "%file",
      },
      ignore_exitcode = true,
    }

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
      lua = { "luacheck" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.diagnostic.config({
      virtual_text = false, -- Disable inline virtual text
      virtual_lines = {
        -- Only show virtual lines for the current line
        current_line = true,
      },
    })

    vim.api.nvim_create_user_command("LintInfo", function()
      local filetype = vim.bo.filetype
      local linters = require("lint").linters_by_ft[filetype]

      if linters then
        print("Linters for filetype '" .. filetype .. "': " .. table.concat(linters, ", "))
      else
        print("No linters configured for filetype '" .. filetype .. "'")
      end
    end, {})

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
