return {
  "neovim/nvim-lspconfig",
  lazy = false,
  opts = {},
  config = function()
    local pylsp_exec = "/home/nguyencodervn02/.venv/nvim/bin/pylsp"

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if cmp_status then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    local custom_actions = require("custom_code_action")

    -- Custom code action menu
    local function show_code_actions()
      local params = vim.lsp.util.make_range_params()
      params.context = { diagnostics = vim.diagnostic.get(0) }

      vim.lsp.buf_request_all(0, "textDocument/codeAction", params, function(results)
        local actions = {}

        -- lấy action từ LSP
        for _, res in pairs(results) do
          if res.result then
            vim.list_extend(actions, res.result)
          end
        end

        -- thêm custom action
        table.insert(actions, {
          title = "🔠 Convert word under cursor to UPPER_CASE",
          kind = "quickfix",
          action = function()
            custom_actions.run_uppercase()
          end,
        })

        if vim.tbl_isempty(actions) then
          vim.notify("No code actions available")
          return
        end

        -- popup menu chọn action
        vim.ui.select(actions, {
          prompt = "Code Actions",
          format_item = function(a)
            return a.title
          end,
        }, function(choice)
          if not choice then
            return
          end
          if choice.action then
            choice.action()
          elseif choice.command then
            vim.lsp.buf.execute_command(choice.command)
          elseif choice.edit then
            vim.lsp.util.apply_workspace_edit(choice.edit, "utf-8")
          end
        end)
      end)
    end

    vim.keymap.set("n", "<leader>uu", function()
      require("custom_code_action").run_uppercase()
    end, { desc = "Convert word under cursor to UPPER_CASE" })

    local on_attach = function(__client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- Go-to
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

      -- Hover / signature
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

      -- Workspace
      vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)

      -- Rename / code action
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", show_code_actions, opts)

      -- Diagnostics
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
    end

    vim.lsp.config.lua_ls = {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
        },
      },
    }

    vim.lsp.config.pylsp = {
      cmd = { pylsp_exec },
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        pylsp = {
          plugins = {
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            pylint = { enabled = true },
          },
        },
      },
    }
  end,
}
