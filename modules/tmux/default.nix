{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    shell = "${pkgs.zsh}/bin/zsh";

    # ── Latency ───────────────────────────────────────────────────────────────
    # home-manager defaults escapeTime to 500ms: after Esc, tmux waits half a
    # second to see whether it's the start of a key sequence. In vim that's a
    # visible stall on every mode change. `sensible` was already zeroing this
    # at runtime, but leaning on a plugin to fix a default means it silently
    # regresses the day that plugin goes.
    escapeTime = 0;

    # Same story — these were only ever coming from `sensible`.
    historyLimit = 50000;
    aggressiveResize = true;
    focusEvents = true;

    # Resize panes by dragging, scroll back with the wheel. Copy mode still
    # behaves normally; drag-select copies via the yank plugin.
    mouse = true;

    # `tmux-256color` (not `screen-256color`) is what advertises 256 colours,
    # italics and the extended capabilities tmux supports. This option said
    # screen-256color and extraConfig then overrode it to tmux-256color — two
    # sources of truth for one setting.
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
    ];

    extraConfig = ''
      set -g default-command "${pkgs.zsh}/bin/zsh"

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # TERMINAL CAPABILITIES
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      # `terminal-features` is the modern replacement for the old
      # `terminal-overrides ",xterm-256color:Tc"` incantation: it describes what
      # the *outer* terminal can do, keyed on its TERM. Ghostty reports
      # xterm-ghostty.
      set -as terminal-features ",xterm-256color:RGB"
      set -as terminal-features ",xterm-ghostty:RGB"
      set -as terminal-features ",alacritty:RGB"
      set -as terminal-features ",*256col*:RGB"

      # Undercurl + coloured underlines, so LSP diagnostics in neovim render as
      # squiggles instead of flat underlines.
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

      # Let the cursor shape follow the application (vim block vs beam) instead
      # of tmux flattening it.
      set -as terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'

      # Pass OSC sequences straight through: OSC 52 clipboard, OSC 8 hyperlinks
      # and the Kitty image protocol all break without this.
      set -g allow-passthrough on

      # OSC 52. This is what makes a yank inside tmux on the pi5, over SSH,
      # land in this Mac's clipboard.
      set -g set-clipboard on

      # tmux 3.5+ forwards extended keys (CSI u) — that's how a terminal can
      # tell C-i from Tab, or send S-Enter. "always" forwards them even to
      # applications that never asked.
      set -s extended-keys always
      set -as terminal-features ",*:extkeys"

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # BEHAVIOUR
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      setw -g pane-base-index 1

      # Without this, closing window 2 of 1..4 leaves a hole at 2 forever —
      # which matters here because the numpad Karabiner bindings jump by index.
      set -g renumber-windows on

      # Killing a session drops you into another one rather than ejecting you
      # out of tmux entirely.
      set -g detach-on-destroy off

      set -g set-titles on
      set -g set-titles-string "#S · #W"

      set -g display-time 2500
      set -g display-panes-time 2000

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # OBSIDIAN AURORA THEME
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'bg=#0d1117,fg=#6e7681'

      # The only shell-out in this status line is continuum's save hook (added
      # at the bottom of this file), and that script early-returns unless the
      # save interval has elapsed. 5s is plenty for a clock showing minutes,
      # and keeps that hook cheap.
      set -g status-interval 5

      set -g status-left-length 100
      set -g status-right-length 100

      set -g status-left '#[bg=#161b22,fg=#58a6ff,bold]  #S #[bg=#0d1117,fg=#161b22]#[default]  '

      set -g window-status-format '#[fg=#6e7681] #I #W '
      set -g window-status-current-format '#[fg=#58a6ff,bold] #I #[fg=#c9d1d9]#W#{?window_zoomed_flag,#[fg=#d29922] ,} '
      set -g window-status-separator '#[fg=#2d333b]·#[default]'

      # Windows with unseen output get a subtle colour change rather than a
      # message overlay stealing the screen.
      set -g monitor-activity on
      set -g visual-activity off
      set -g window-status-activity-style 'fg=#d29922,none'
      set -g window-status-bell-style 'fg=#ff7b72,none'

      set -g pane-border-style 'fg=#2d333b'
      set -g pane-active-border-style 'fg=#58a6ff'
      set -g pane-border-lines heavy

      set -g message-style 'bg=#161b22,fg=#79c0ff,bold'
      set -g message-command-style 'bg=#161b22,fg=#d29922'
      set -g mode-style 'bg=#2d333b,fg=#c9d1d9'

      set -g clock-mode-colour '#58a6ff'
      set -g clock-mode-style 24

      set -g popup-border-style 'fg=#58a6ff'
      set -g popup-border-lines rounded

      set -g status-right '#[bg=#2d333b,fg=#7ee787]  #{?client_prefix,#[fg=#d29922]󰌌 ,}#[fg=#6e7681]%H:%M #[bg=#161b22,fg=#bc8cff]  %d %b #[default]'

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # VIM INTEGRATION
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind-key -r -T prefix K resize-pane -U 5
      bind-key -r -T prefix J resize-pane -D 5
      bind-key -r -T prefix H resize-pane -L 5
      bind-key -r -T prefix L resize-pane -R 5
      bind-key -T prefix z resize-pane -Z

      # -d keeps focus on the window you're moving, so you can shove it several
      # positions without chasing it.
      bind-key -n C-S-h swap-window -d -t -1
      bind-key -n C-S-l swap-window -d -t +1

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # COPY MODE (vi)
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
      bind-key -T copy-mode-vi 'Escape' send -X cancel

      # Mouse drag-select copies without also snapping the view to the bottom.
      unbind -T copy-mode-vi MouseDragEnd1Pane
      bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe

      # prefix-/ searches back through scrollback, like a pager.
      bind-key / copy-mode \; send-keys ?

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # QUALITY OF LIFE
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      # New splits and windows open where you already are.
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind N run-shell 'tmux rename-window "$(basename \"#{pane_current_path}\")"'
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded"

      # Sessionizer in a centred popup instead of a throwaway window. The old
      # `tmux neww` flashed a real window into the list and shifted every index
      # while fzf was open.
      bind f display-popup -E -w 70% -h 60% -T ' projects ' "~/.scripts/tmux-sessionizer"

      # Toggle to the previous session. With two sessions this ends up being
      # the single most-used binding there is.
      bind Space switch-client -l

      # Built-in fuzzy session/window tree — no plugin needed.
      bind s choose-tree -Zs

      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      # SESSION PERSISTENCE
      # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'

      # IMPORTANT: continuum implements its periodic save by prepending a `#(…)`
      # interpolation to status-right when its plugin script runs. home-manager
      # sources plugins *before* extraConfig, so the `set -g status-right`
      # above wiped that hook out, so the *periodic* save never ran. Evidence:
      # ~/.tmux/resurrect held 4 saves across 100 days (17 Apr, 24 Apr, 13 Jun,
      # 25 Jul) — the fingerprint of occasional manual `prefix + C-s`, not of a
      # 15-minute timer, which would have left hundreds.
      #
      # Re-running continuum.tmux here would restore the hook, but it would
      # also re-run start_auto_restore_in_background and
      # handle_tmux_automatic_start a second time. Adding the interpolation
      # ourselves is deterministic and side-effect free. It also sidesteps
      # continuum's `another_tmux_server_running` guard, which silently skips
      # hook registration whenever a second tmux server happens to be up.
      set -ag status-right '#(${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/scripts/continuum_save.sh)'
    '';
  };
}
