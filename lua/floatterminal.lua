local M = {}

local floatwindow = require("floatwindow")

local win_width = vim.api.nvim_win_get_width(0)
local win_height = vim.api.nvim_win_get_height(0)
local bar_width = math.floor(win_width * 0.9)
local bar_height = math.floor((win_height * 0.6) / 2)
local row = (win_height - math.floor(bar_height / 2)) - 8
local col = math.floor((win_width - bar_width) / 2)

local float_width = math.floor(win_width * 0.8)
local float_height = math.floor(win_height * 0.8)

local float_row = math.floor((win_height - float_height) / 2)
local float_col = math.floor((win_width - float_width) / 2)

local preset_window_config = {
  bar = {
    relative = 'editor',
    style = 'minimal',
    width = bar_width,
    height = bar_height,
    row = row,
    col = col,
    border = 'rounded',
  },
  float = {
    relative = "editor",
    width = float_width,
    height = float_height,
    row = float_row,
    col = float_col,
    style = "minimal",
    border = "rounded",
  }
}

local window_config = nil

---Creates a floating terminal that keeps its state when closed
---@param state state.Floating
M.toggle_terminal = function(state)
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = floatwindow.create_floating_window({ opts = window_config, floating = state.floating })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end

    local float = state.floating

    vim.keymap.set("n", "<Esc><Esc>", function()
      vim.api.nvim_win_hide(float.win)
    end, { buffer = float.buf })

    vim.keymap.set('n', '<leader>tk', function()
      window_config = preset_window_config.float
      vim.api.nvim_win_set_config(float.win, window_config or {})
    end, { buffer = float.buf })

    vim.keymap.set('n', '<leader>tj', function()
      window_config = preset_window_config.bar
      vim.api.nvim_win_set_config(float.win, window_config or {})
    end, { buffer = float.buf })
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

local states = {}

local config = {
  num = 3,
}

local floatterminal_command = function(opts)
  local index, command = opts.args:match("(%d*)[ ]*(.*)")

  index = tonumber(index or opts.args)

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

  if vim.api.nvim_win_is_valid(state.floating.win) and command and command:gsub(" ", ""):len() > 0 then
    vim.print(command)
    local clear = vim.api.nvim_replace_termcodes(command .. "<CR><C-\\><C-N>", true, false, true)
    vim.api.nvim_feedkeys("i" .. clear, "n", false)
  end
end

vim.api.nvim_create_user_command("Floatterminal", floatterminal_command, { nargs = '*' })

---@class setup.Opts
---@field num integer?: Optional: Number of floating terminal you want. DEFAULT 3
---@field keymap string?: Optional: Keymap to open floating terminal, will be your key map plus the number of the terminal, from 1 to num. DEFAULT: <leader>t
---@field window_config 'bar'|'float'?: Optional: 'bar' | 'float'

---Setup floatterminal plugin
---@param opts setup.Opts|nil
M.setup = function(opts)
  opts = opts or {}

  window_config = (opts.window_config == 'bar' and preset_window_config.bar) or preset_window_config.float

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
