local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = "➜ ",
    path_display = { "truncate" },
    file_ignore_patterns = {
      "node_modules",
      ".git/",
      "dist/",
      "build/",
      "%.lock",
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close,
      },
      n = {
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["q"] = actions.close,
      },
    },
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
      hidden = true,
    },
    git_files = {
      theme = "dropdown",
      previewer = false,
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer,
        },
        n = {
          ["dd"] = actions.delete_buffer,
        },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

-- Load fzf extension for better performance
pcall(telescope.load_extension, 'fzf')

-- Keybindings
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Find git files" })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help tags" })
vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = "Grep string under cursor" })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = "Commands" })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = "Recent files" })
