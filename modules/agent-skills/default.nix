# Agent skills shared by Claude Code and pi.
#
# Each directory under skills/ is linked to ~/.claude/skills/<name>. That
# directory is the single skill source for both agents: Claude Code reads it
# natively, and the pi-agent module points pi's `skills` setting at it, so a
# skill added here shows up in both without a second copy (and pi never sees
# duplicates).
#
# ~/.claude/skills is shared with imperative installers (gstack drops dozens
# of skills there), so the module links one entry per skill instead of
# managing the whole directory — managing it wholesale would delete those.
# A name collision with an imperatively installed skill makes home-manager
# abort activation ("would be clobbered") instead of overwriting; rename the
# skill here or remove the imperative copy.
#
# Adding a skill = creating skills/<name>/SKILL.md. No Nix changes needed.
{ lib, ... }:

let
  skillsDir = ./skills;

  skills = lib.filterAttrs (_: type: type == "directory") (builtins.readDir skillsDir);
in
{
  home.file = lib.mapAttrs'
    (name: _: lib.nameValuePair ".claude/skills/${name}" {
      source = skillsDir + "/${name}";
      recursive = true;
    })
    skills;
}
