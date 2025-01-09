## floatterminal.nvim

*A Neovim Plugin that provides persistent floaterminals that continue running even when closed.*

**Features:**

* Create and manage multiple persistent floaterminals.
* Floaterminals remain active in the background.

**Dependencies:**

* `leonardo-luz/floatwindow`

**Installation:**  Add `leonardo-luz/floatterminal.nvim` to your Neovim plugin manager (e.g., `init.lua` or `plugins/floatterminal.lua`).

```lua
{
    'leonardo-luz/floatterminal.nvim',
    opts = {
        num = 3,  -- Maximum number of floaterminals (default: 3)
        keymap = '<leader>t', -- Keymapping to open a floaterminal (default: `<leader>t`)
    },
},
```

**Usage:**

* `<leader>t{1, num}`: Opens a floaterminal.  Replace `{1, num}` with the desired floaterminal number (1 to `num` as configured above).
* `<Esc><Esc>`: Closes the currently active floaterminal.
