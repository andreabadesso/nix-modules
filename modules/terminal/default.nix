{ config, pkgs, lib, ... }:

{
  # Ghostty config - package installed manually on macOS, via nixpkgs on Linux
  xdg.configFile."ghostty/config".text = ''
    # Window
    window-padding-x = 16
    window-padding-y = 12
    window-decoration = none
    window-opacity = 0.92
    background-blur = true
    title = Ghostty
    
    # Font
    font-family = JetBrainsMono Nerd Font
    font-size = 15
    font-thicken = true
    
    # Scrolling
    scrollback-limit = 10000
    
    # Cursor
    cursor-style = block
    cursor-style-blink = true
    
    # Clipboard
    clipboard-read = allow
    clipboard-write = allow
    copy-on-select = true
    
    # Shell
    shell-integration = detect
    command = /bin/zsh -l
    
    # Obsidian Aurora Theme
    background = #0d1117
    foreground = #c9d1d9
    
    palette = 0=#161b22
    palette = 1=#ff7b72
    palette = 2=#7ee787
    palette = 3=#d29922
    palette = 4=#58a6ff
    palette = 5=#bc8cff
    palette = 6=#56d4dd
    palette = 7=#c9d1d9
    palette = 8=#2d333b
    palette = 9=#ffa198
    palette = 10=#a5f3b5
    palette = 11=#e6b345
    palette = 12=#79c0ff
    palette = 13=#d2a8ff
    palette = 14=#76e4eb
    palette = 15=#f0f3f6
    
    cursor-color = #58a6ff
    selection-background = #2d333b
    selection-foreground = #c9d1d9
  '';
}
