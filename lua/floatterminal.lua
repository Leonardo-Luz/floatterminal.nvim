local M = {}

local floatwindow = require("floatwindow")

M.toggle_terminal = function(state)
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = floatwindow.create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- make this have n numbers of terminals
local states = {}
for i = 0, 2 do
  states[i] = { floating = { buf = -1, win = -1 } }
end

local function toggle_terminal(state_index)
  M.toggle_terminal(states[state_index])
end

for i = 1, 3 do
  vim.keymap.set("n", "<leader>t" .. i, function()
    toggle_terminal(i - 1)
  end, { desc = "[T]oggle terminal [" .. i .. "]" })
end

vim.api.nvim_create_user_command("Floaterminal", M.toggle_terminal, {})
