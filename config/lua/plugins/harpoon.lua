local harpoon = require("harpoon")

harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
    key = function()
      return vim.loop.cwd()
    end,
  },
})

-- Keybindings
vim.keymap.set("n", "<leader>ma", function() harpoon:list():add() end, { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>mm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

-- Quick navigation to marked files
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Harpoon file 5" })

-- Navigate between marked files
vim.keymap.set("n", "<leader>mp", function() harpoon:list():prev() end, { desc = "Harpoon previous" })
vim.keymap.set("n", "<leader>mn", function() harpoon:list():next() end, { desc = "Harpoon next" })
