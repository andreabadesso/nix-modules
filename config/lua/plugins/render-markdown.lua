require('render-markdown').setup({
  -- Enable by default
  enabled = true,
  -- Maximum file size to render (in MB)
  max_file_size = 1.5,
  -- Debounce rendering (ms)
  debounce = 100,
  -- Filetypes to enable on
  file_types = { 'markdown' },
})
