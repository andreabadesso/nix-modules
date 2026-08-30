# Declarative setup for pi (https://pi.dev), the pay-per-token coding agent
# used when Claude Code limits run out.
#
# What this module does:
#   - installs pi-coding-agent from nixpkgs-unstable (not in stable nixpkgs
#     yet). The consumer must pass `nixpkgs-unstable` via extraSpecialArgs,
#     the same contract dev-tools already uses in nixcfg;
#   - links ~/.pi/agent/settings.json to settings.json here. The settings
#     declare extension packages (subagents, web access, MCP, plan mode)
#     that pi installs on startup, and point pi at ~/.claude/skills so pi
#     and Claude Code share one skill set (agent-skills module + gstack's
#     imperative installs);
#   - links each file in agents/ into ~/.pi/agent/agents/ (per-entry, so
#     the directory stays writable for pi-subagents' imperative saves);
#   - links ~/.pi/agent/AGENTS.md to the live ~/.claude/CLAUDE.md so global
#     instructions have a single source of truth.
#
# Caveats:
#   - settings.json is a read-only symlink: in-app commands that persist
#     settings (e.g. /theme) will fail to write. Edit settings.json here
#     and rebuild instead.
#   - the API key comes from the `piloto-harness-key` gopass entry, fetched
#     by the `pi` wrapper at launch (see below). No key, no problem: pi
#     starts anyway and `/login` still works.
{ pkgs, config, nixpkgs-unstable, ... }:

let
  unstable = import nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  # `pi` is a wrapper, not the raw binary: it pulls the OpenRouter key out of
  # gopass at launch and exports it only into the pi process, so the secret
  # never touches the nix store, shell rc files, or `ps` output (which
  # `--api-key` would). An OPENROUTER_API_KEY already set in the environment
  # wins. If gopass fails (no pinentry, key absent), pi still starts —
  # subscription `/login` keeps working.
  home.packages = [
    (pkgs.writeShellScriptBin "pi" ''
      if [ -z "''${OPENROUTER_API_KEY:-}" ]; then
        key="$(${pkgs.gopass}/bin/gopass show -o piloto-harness-key 2>/dev/null)" \
          && export OPENROUTER_API_KEY="$key"
      fi
      exec ${unstable.pi-coding-agent}/bin/pi "$@"
    '')
  ];

  home.file.".pi/agent/settings.json".source = ./settings.json;

  home.file.".pi/agent/agents" = {
    source = ./agents;
    recursive = true;
  };

  home.file.".pi/agent/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.claude/CLAUDE.md";
}
