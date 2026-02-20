require("neotest").setup({
  adapters = {
    require("neotest-jest")({
      jestCommand = "npm test --",
      jestConfigFile = "jest.config.js",
      env = { CI = true },
      cwd = function(path)
        return vim.fn.getcwd()
      end,
    }),
  },
  discovery = {
    enabled = true,
    concurrent = 1,
  },
  running = {
    concurrent = true,
  },
  summary = {
    enabled = true,
    animated = true,
    follow = true,
    expand_errors = true,
  },
  output = {
    enabled = true,
    open_on_run = "short",
  },
  status = {
    enabled = true,
    virtual_text = true,
    signs = true,
  },
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = "✖",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    passed = "✓",
    running = "●",
    running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    skipped = "○",
    unknown = "?",
  },
})

-- Keybindings (using 'j' prefix for jest/tests - verified conflict-free)
vim.keymap.set("n", "<leader>jt", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>jf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run current file tests" })

vim.keymap.set("n", "<leader>jd", function()
  require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

vim.keymap.set("n", "<leader>js", function()
  require("neotest").run.stop()
end, { desc = "Stop test" })

vim.keymap.set("n", "<leader>ja", function()
  require("neotest").run.attach()
end, { desc = "Attach to test" })

vim.keymap.set("n", "<leader>jo", function()
  require("neotest").output.open({ enter = true })
end, { desc = "Show test output" })

vim.keymap.set("n", "<leader>jO", function()
  require("neotest").output_panel.toggle()
end, { desc = "Toggle test output panel" })

vim.keymap.set("n", "<leader>jS", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })
