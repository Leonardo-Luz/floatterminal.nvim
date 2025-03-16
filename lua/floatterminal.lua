local M = {}

local floatwindow = require("floatwindow")

local window_config = nil

---Creates a floating terminal that keeps its state when closed
---@param state state.Floating
M.toggle_terminal = function(state)
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = floatwindow.create_floating_window({ opts = window_config, floating = state.floating })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end

    vim.keymap.set("n", "<Esc><Esc>", function()
      vim.api.nvim_win_hide(state.floating.win)
    end, { buffer = state.floating.buf })
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

local states = {}

local config = {
  num = 3,
}

local floatterminal_command = function(opts)
  local index = tonumber(opts.args)

  if index == nil then
    vim.print("Invalid argument")
    return
  end

  if index > config.num or index < 1 then
    vim.print("Argument should be between 1 and " .. config.num)
    return
  end

  local state = states[index - 1]

  M.toggle_terminal(state)
end

vim.api.nvim_create_user_command("Floatterminal", floatterminal_command, { nargs = 1 })

---@class setup.Opts
---@field num integer?: Optional: Number of floating terminal you want. DEFAULT 3
---@field keymap string?: Optional: Keymap to open floating terminal, will be your key map plus the number of the terminal, from 1 to num. DEFAULT: <leader>t
---@field window_config vim.api.keyset.win_config?: Optional: window opts

---Setup floatterminal plugin
---@param opts setup.Opts|nil
M.setup = function(opts)
  opts = opts or {}

  window_config = opts.window_config

  config.num = opts.num or 3

  for i = 0, (opts.num or 3) - 1 do
    states[i] = { floating = { buf = -1, win = -1 } }
  end

  local function toggle_terminal(state_index)
    M.toggle_terminal(states[state_index])
  end

  for i = 1, (opts.num or 3) do
    vim.keymap.set("n", (opts.keymap or "<leader>t") .. i, function()
      toggle_terminal(i - 1)
    end, { desc = "[T]oggle terminal [" .. i .. "]" })
  end
end

return M
