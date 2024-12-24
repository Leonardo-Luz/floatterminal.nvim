local M = {}

local floatwindow = require("floatwindow")

---Creates a floating terminal that keeps its state when closed
---@param state state.Floating
M.toggle_terminal = function(state)
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = floatwindow.create_floating_window({ floating = state.floating })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

---@class setup.Opts
---@field num integer: Number of floating terminal you want. DEFAULT 3
---@field keymap string: Keymap to open floating terminal, will be your key map plus the number of the terminal, from 1 to num. DEFAULT: <leader>t

---Setup floatterminal plugin
---@param opts setup.Opts
M.setup = function(opts)
  opts = opts or {}

  local states = {}
  for i = 0, (opts.num or 3) - 1 do
    states[i] = { floating = { buf = -1, win = -1 } }
  end

  local function toggle_terminal(state_index)
    M.toggle_terminal(states[state_index])
  end

  for i = 1, (opts.num or 3) do
    vim.keymap.set("n", (opts.keymap or "<leader>t") .. i, function()
      toggle_terminal(states[i - 1])
    end, { desc = "[T]oggle terminal [" .. i .. "]" })
  end

  ---@deprecated
  vim.api.nvim_create_user_command("Floaterminal", M.toggle_terminal, { nargs = 1 })
end
