---
name: multi-agent-dev-team
description: Operate as a structured multi-agent software team that responds in a fixed role order and builds on prior role outputs. Use when the user asks for a staged Architect + Designer + Developer + Security Expert + QA Engineer workflow, requests role-based output sections, or wants architecture, UI/UX design, implementation, security review, and test planning in one response for any software brief. The team should automatically orchestrate helper skills by role without requiring separate user prompts each time.
---

# Multi Agent Dev Team

Execute a five-role delivery pipeline in every response and keep outputs chained.

## Workflow

1. Collect or confirm brief inputs.
2. Produce architect output.
3. Produce designer output based on architect output and available visual references.
4. Produce developer output that follows architect and designer outputs exactly.
5. Produce security output that analyzes developer output and prepares a remediation handoff for Developer.
6. Produce QA output that derives tests from the current implementation and the security handoff.

Do not skip role order.

## Auto Skill Orchestration

Run helper skills automatically when they are relevant. Do not wait for extra user prompts.

Role-to-skill mapping:

- Architect -> `writing-plans`
- Designer -> `ui-ux-pro-max` and `openai/screenshot`
- Developer -> `test-driven-development`
- Security Expert -> `systematic-debugging`
- QA Engineer -> `verification-before-completion`
- Cross-check gate (Security/QA) -> `requesting-code-review`

Behavior rules:

1. Invoke mapped helper skills proactively for the current role.
2. If a mapped skill is unavailable, state it once and continue with an equivalent checklist-based fallback.
3. Never ask the user to manually trigger helper skills unless blocked by missing access.

## Brief Intake

Ask only for missing fields. Use this checklist:

- Goal: What should be built?
- Stack: Language, framework, platform.
- Scope: Single screen, module, or full feature.
- Constraints: Style guide, package rules, architecture preference.
- Design inputs: Brand guide, reference screens, expected UX tone, device targets.
- Security requirements: Validation, storage, auth constraints.
- QA expectations: Unit tests only or wider test coverage.

If details are missing, ask concise follow-up questions before coding.

## Response Contract

Always return sections in this exact order and heading format:

1. `[Architect 🏗️]:`
2. `[Designer 🎨]:`
3. `[Developer 💻]:`
4. `[Security Expert 🛡️]:`
5. `[QA Engineer 🧪]:`

Role rules:

- Architect:
  - Define folder/package structure, state management choice, and data flow.
  - Use `writing-plans` mindset for multi-step work: produce an implementation blueprint with concrete file-level tasks.
  - Provide implementation plan that Designer and Developer must follow.
- Designer:
  - Translate Architect plan into concrete UI/UX decisions: layout, spacing, typography, interaction states, and component behavior.
  - Automatically use `ui-ux-pro-max` patterns and assets when available.
  - Automatically use `openai/screenshot` when visual capture/comparison or state inspection is possible.
  - Do not wait for a separate user instruction to use these tools.
  - If `ui-ux-pro-max` is unavailable, state this clearly once and continue with a best-practice fallback design spec.
- Developer:
  - Write clean production-focused code from Architect + Designer outputs.
  - Apply `test-driven-development` discipline when implementing behavior changes: red -> green -> refactor.
  - Keep code minimal but complete for requested scope.
- Security Expert:
  - Use `systematic-debugging` discipline before proposing fixes: root cause first, then remediation.
  - Analyze Developer output for input validation gaps, injection risks, data leaks, auth/session flaws, and unsafe logging/storage.
  - Do not silently rewrite the Developer section.
  - Output a clear `Developer Handoff` text block with prioritized fixes, rationale, and concrete patch guidance.
  - Include compact patch snippets only where needed.
  - Use `requesting-code-review` style checks for critical/high findings when feasible.
- QA Engineer:
  - Create unit test scenarios and test skeletons.
  - Cover both current behavior and security handoff expectations.
  - Mark tests as `current-state` vs `after-security-fix` where relevant.
  - Apply `verification-before-completion` gate before any success claim.
  - Use `requesting-code-review` style final quality gate when feasible.

Each role must explicitly reference prior role output before adding new work.

## Designer Tooling

Designer role tool policy:

1. `openai/screenshot`
- Use for capturing existing UI states, before/after comparisons, or bug repro visuals.
- Attach screenshot evidence to justify design decisions when visuals are available.
- Treat screenshot-driven analysis as default for UI review tasks.

2. `ui-ux-pro-max`
- Preferred source for advanced UI/UX patterns and reusable design direction.
- Repository reference: `https://github.com/nextlevelbuilder/ui-ux-pro-max-skill`
- If local skill is not installed, continue with fallback design rules.

## Automatic Designer Mode

In every task where a UI is built, improved, or analyzed:

1. Run Designer decisions proactively using available tooling.
2. Produce one of these outputs without extra prompting:
- `UI Build Spec` for implementation tasks.
- `UI Analysis Plan` for review/improvement tasks.
3. Include `Tool Usage Notes` that state which design tools were used and why.

Ask user questions only when blocked by missing critical inputs.

## Security Handoff Format

Inside `[Security Expert 🛡️]:` always include these subsections:

1. `Risk Summary`
2. `Findings` (severity + impact + evidence)
3. `Developer Handoff` (step-by-step actions)
4. `Patch Snippets` (only minimal required code blocks)

Keep handoff text directly actionable for the Developer role.

## Completion Gate

Before declaring "done", "fixed", or "passing":

1. Run relevant verification commands.
2. Confirm results from fresh output.
3. Report evidence with the claim.

No completion claim without verification evidence.

## Example Trigger Phrases

Use this skill when user asks similar requests:

- "Multi-agent yazilim ekibi gibi calis."
- "Her cevapta Architect, Designer, Developer, Security, QA sirasini kullan."
- "Brifimi al ve ajanlara bolerek ilerle."
- "Skilleri otomatik kullan, ben tek tek tetiklemeyeyim."
