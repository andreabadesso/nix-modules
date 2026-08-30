# Custom pi subagents

Each `.md` file in this directory becomes a subagent available to
[pi-subagents](https://github.com/nicobailon/pi-subagents), on top of the
builtin ones (`scout`, `researcher`, `worker`, `reviewer`, `oracle`,
`delegate`).

Files are linked one by one into `~/.pi/agent/agents/` by
`modules/home/pi-agent.nix`, so the directory stays writable for anything
pi-subagents saves there imperatively (same pattern as the Claude skills
module). Add an agent here, rebuild, done.

Format (Claude Code subagent-compatible frontmatter):

```markdown
---
name: my-agent
description: When the parent should pick this agent.
---

System prompt for the agent goes here.
```

See <https://github.com/nicobailon/pi-subagents/blob/main/docs/custom-agents.md>
for model overrides, tool restrictions, and per-agent settings.
