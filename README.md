## floatterminal.nvim

*A Neovim Plugin that provides persistent floaterminals that continue running even when closed.*

**Features:**

* Create and manage multiple persistent floaterminals.
* Floaterminals remain active in the background.

**Dependencies:**

* `leonardo-luz/floatwindow.nvim`

**Installation:**  Add `leonardo-luz/floatterminal.nvim` to your Neovim plugin manager (e.g., `init.lua` or `plugins/floatterminal.lua`).

```lua
{
    'leonardo-luz/floatterminal.nvim',
    opts = {
        num = 3,  -- Optional: Maximum number of floaterminals (default: 3)
        keymap = '<leader>t', -- Optional: Keymapping to open a floaterminal (default: `<leader>t`)
        window_config = {}, -- Optional: Terminal window style
    },
},
```

**Usage:**

* `:Floatterminal {args}`: Opens a floatterminal.  Example: `:Floatterminal {1} [command]`, where the command is optional.
* `<leader>t{1, num}`: Opens floatterminal number {1, num}, where num is the maximum configured floatterminal number.
* `<Esc><Esc>`: Closes the currently active floatterminal.
* `<leader>tj`: Shrinks the currently active floatterminal to a bar.
* `<leader>tk`: Expands the currently active floatterminal.

**Examples:**

```lua
--- Create a keymap to print "hello world" in the first terminal
vim.keymap.set('n', '<leader>th', function()
    vim.cmd 'Floatterminal 1 echo "hello world"'
end, { desc = "[T]erminal Run [H]ello World" })
```

```lua
--- Create a keymap to run a node application in the first terminal
vim.keymap.set('n', '<leader>tn', function()
    vim.cmd 'Floatterminal 1 npm run dev'
end, { desc = "[T]erminal Run [N]ode App" })
```
