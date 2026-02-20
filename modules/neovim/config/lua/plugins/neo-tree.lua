require("neo-tree").setup({
  close_if_last_window = false,  -- Keep neo-tree open even when it's the last window
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
    },
    icon = {
      folder_closed = "▸",  -- Clear visual indicator for closed folders
      folder_open = "▾",    -- Clear visual indicator for open folders
      folder_empty = "▸",   -- Same as closed for empty folders
      default = " ",        -- Files have no icon prefix
    },
    git_status = {
      symbols = {
        added     = "✚",
        modified  = "",
        deleted   = "✖",
        renamed   = "➜",
        untracked = "★",
        ignored   = "◌",
        unstaged  = "✗",
        staged    = "✓",
        conflict  = "",
      }
    },
  },
  window = {
    position = "left",
    width = 30,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ["<space>"] = {
        "toggle_node",
        nowait = false,
      },
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["o"] = "open",
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      ["t"] = "open_tabnew",
      ["C"] = "close_node",
      ["z"] = "close_all_nodes",
      ["R"] = "refresh",
      ["a"] = {
        "add",
        config = {
          show_path = "none"
        }
      },
      ["A"] = "add_directory",
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy",
      ["m"] = "move",
      ["q"] = "close_window",
      ["?"] = "show_help",
      ["/"] = "noop",  -- Disable filter/search
      ["f"] = "noop",  -- Disable filter
      ["<C-x>"] = "noop",  -- Disable clear filter
    }
  },
  filesystem = {
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        ".DS_Store",
        "thumbs.db",
        "node_modules",
      },
    },
    follow_current_file = {
      enabled = true,
    },
    use_libuv_file_watcher = true,
  },
})

-- Keep your familiar binding
vim.keymap.set('n', '<leader>nt', '<cmd>Neotree toggle<CR>', { noremap = true, silent = true, desc = "Toggle Neo-tree" })
