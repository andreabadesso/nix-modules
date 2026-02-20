{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    defaultKeymap = "vicmd";

    shellAliases = {
      yt = "fabric -y";
      vnc = "f() { open \"http://$1\"; }; f";
      pwd = "print -P '%~'";
    };

    dirHashes = {
      dev = "$HOME/Dev";
      myio = "$HOME/Dev/myio";
      hathor = "$HOME/Dev/hathor";
    };

    sessionVariables = {
      LEDGER_FILE = "$HOME/.config/hledger/main.journal";
      DIRENV_LOG_FORMAT = "";
      PATH = "$HOME/.local/bin:$HOME/.npm/bin:$PATH";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        export EDITOR="nvim"
        export VISUAL="nvim"

        setopt NO_BEEP
        setopt NO_LIST_BEEP
        setopt NO_HIST_BEEP
        unsetopt verbose
        unsetopt xtrace
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
        setopt NO_BEEP
        unsetopt verbose
        unsetopt xtrace

        export PATH="$HOME/.local/bin:$HOME/.npm/bin:$PATH"

        # Auto-start tmux if not already in tmux and in an interactive shell
        if [ -z "$TMUX" ] && [ -n "$PS1" ] && [[ ! "$TERM_PROGRAM" == "vscode" ]]; then
          tmux attach-session -t default 2>/dev/null || tmux new-session -s default
        fi
      '')
    ];
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
      "syntax-highlighting"
    ];
  };

  programs.mcfly = {
    enable = true;
    fuzzySearchFactor = 3;
    enableZshIntegration = true;
  };
}
