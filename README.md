# Multi-Agent Dev Team Skill

A Codex skill that runs a structured software workflow with fixed role order:

1. Architect
2. Designer
3. Developer
4. Security Expert
5. QA Engineer

The skill is designed for any software brief and enforces chained outputs where each role references the previous role.

## Key Behavior

- Designer proactively uses `ui-ux-pro-max` patterns when available.
- Designer proactively uses `openai/screenshot` for visual analysis when possible.
- Security Expert produces a `Developer Handoff` with prioritized fixes.
- QA Engineer derives tests from implementation and security findings.

## Skill Files

- `SKILL.md`: Main behavior and response contract.
- `agents/openai.yaml`: UI metadata and default prompt.

## Usage Example

```md
[$multi-agent-dev-team](/Users/<you>/.codex/skills/multi-agent-dev-team/SKILL.md)
Brif: <your software brief>
```

## Repository

- GitHub: https://github.com/gulcint/multi-agent-dev-team-skill
