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
#   - API keys are NOT managed here. Export the provider key in the shell
#     (e.g. OPENROUTER_API_KEY, DEEPSEEK_API_KEY) or use `pi /login`.
{ pkgs, config, nixpkgs-unstable, ... }:

let
  unstable = import nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  home.packages = [ unstable.pi-coding-agent ];

  home.file.".pi/agent/settings.json".source = ./settings.json;

  home.file.".pi/agent/agents" = {
    source = ./agents;
    recursive = true;
  };

  home.file.".pi/agent/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.claude/CLAUDE.md";
}
