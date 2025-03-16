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

* `:Floatterminal {args}`: Opens a floatterminal
* `<leader>t{1, num}`: Opens a floatterminal.  Replace `{1, num}` with the desired floatterminal number (1 to `num` as configured above).
* `<Esc><Esc>`: Closes the currently active floatterminal.
