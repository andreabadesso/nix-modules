{ config, pkgs, lib, ... }:

{
  # PATH additions live here rather than in `programs.zsh.sessionVariables`.
  # They used to be set in *both* sessionVariables and the mkOrder 1000 block,
  # so every interactive shell had ~/.local/bin and ~/.npm/bin on PATH twice.
  # home.sessionPath is also picked up by non-zsh consumers (launchd agents,
  # GUI apps) instead of only by interactive zsh.
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm/bin"
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "vicmd";

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    shellAliases = {
      yt = "fabric -y";
      vnc = "f() { open \"http://$1\"; }; f";
      pwd = "print -P '%~'";

      # nixcfg shortcuts — these are the commands typed most often on this
      # machine, and they were being retyped in full every time.
      nrs = "nix run ~/.config/nixcfg#build-switch";
      nrb = "nix run ~/.config/nixcfg#build";
      nrc = "nix run ~/.config/nixcfg#clean";
      ncd = "cd ~/.config/nixcfg";
    };

    dirHashes = {
      dev = "$HOME/Dev";
      myio = "$HOME/Dev/myio";
      hathor = "$HOME/Dev/hathor";
      nixcfg = "$HOME/.config/nixcfg";
    };

    sessionVariables = {
      LEDGER_FILE = "$HOME/.config/hledger/main.journal";
      DIRENV_LOG_FORMAT = "";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        setopt NO_BEEP
        setopt NO_LIST_BEEP
        setopt NO_HIST_BEEP
        unsetopt verbose
        unsetopt xtrace

        # vi-mode typing lag: KEYTIMEOUT is the wait (in 10ms units) zsh does
        # to tell Esc alone apart from escape-prefixed sequences (arrows send
        # ^[OA/^[[A). Default 40 = 400ms of delay every time you leave insert
        # mode; 10 = 100ms is enough for the sequence and kills the lag.
        KEYTIMEOUT=10
      '')

      # Obsidian Aurora Prompt
      (lib.mkOrder 800 ''
        autoload -Uz vcs_info
        precmd() { vcs_info }
        setopt PROMPT_SUBST

        zstyle ':vcs_info:git:*' formats ' %F{#58a6ff} %b%f'
        zstyle ':vcs_info:git:*' actionformats ' %F{#58a6ff} %b%f %F{#d29922}⚡%a%f'

        PROMPT='%F{#484f58}%T%f %F{#79c0ff}%~%f''${vcs_info_msg_0_} %F{#7ee787}λ%f '
        RPROMPT='%(?..%F{#ff7b72}✘ %?%f)'
      '')


      (lib.mkOrder 1000 ''
        # Auto-start tmux, but only for a real interactive terminal. Without
        # the `-t 0` check this fires for non-tty shells too (scp, rsync,
        # `ssh host cmd`), which hangs the connection.
        # HERDR_ENV=1 marks a pane living inside herdr, which sets it exactly
        # so multiplexer auto-attach chains like this one stay out of its
        # panes; without the check every herdr pane spawned a nested tmux.
        if [ -z "$HERDR_ENV" ] && [ -z "$TMUX" ] && [ -n "$PS1" ] && [ -t 0 ] && [[ ! "$TERM_PROGRAM" == "vscode" ]]; then
          tmux attach-session -t default 2>/dev/null || tmux new-session -s default
        fi
      '')
    ];
      # ctrl+backspace deletes the previous word. Inside herdr panes the key
      # arrives as legacy ^H (0x08), which zsh binds to backward-delete-char
      # — one character. Plain backspace is a different key (0x7f), so
      # rebinding ^H costs nothing; the kitty-protocol CSI-u form is bound
      # too for terminals that send it. Insert-mode maps only: in vicmd,
      # ^H stays backward-char.
      #
      # Bound in initExtra, AFTER the prezto source: prezto's editor module
      # re-initializes the keymaps (bindkey -v), wiping anything bound in
      # initContent blocks, which all render before it.
      programs.zsh.initExtra = ''
        bindkey -M viins '^H' backward-kill-word
        bindkey -M viins '\e[27;5;127~' backward-kill-word
        bindkey -M emacs '^H' backward-kill-word
        bindkey -M emacs '\e[27;5;127~' backward-kill-word
      '';
  };

  programs.bash.enable = true;

  programs.zsh.prezto = {
    enable = true;
    pmodules = [
      "environment"
      "terminal"
      "history"
      "directory"
      "spectrum"
      "completion"
      "history-substring-search"
    ];
  };

  programs.mcfly = {
    enable = true;
    fuzzySearchFactor = 3;
    enableZshIntegration = true;
  };
}
