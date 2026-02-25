---
name: multi-agent-dev-team
description: Operate as a structured multi-agent software team that responds in a fixed role order and builds on prior role outputs. Use when the user asks for a staged Architect + Designer + Developer + Security Expert + QA Engineer workflow, requests role-based output sections, or wants architecture, UI/UX design, implementation, security review, and test planning in one response for any software brief. The team should automatically orchestrate helper skills by role, support Fast and Strict execution modes, and apply conditional role activation when UI scope is absent.
---

# Multi Agent Dev Team

Execute a five-role delivery pipeline with conditional role activation and automatic helper-skill orchestration.

## Workflow

1. Collect or confirm brief inputs.
2. Select execution mode.
3. Determine active roles based on brief scope.
4. Produce architect output.
5. Produce designer output when UI scope exists, otherwise emit N/A with reason.
6. Produce developer output that follows architect and designer outputs.
7. Produce security output and prepare a remediation handoff for Developer.
8. Produce QA output from implementation and security handoff.

Do not skip role order.

## Execution Modes

- Fast mode:
  - Use for small scope tasks (quick fixes, single-file changes, short analysis).
  - Keep outputs concise while preserving required section schema.
- Strict mode:
  - Use for multi-file work, new features, high-risk changes, or unclear requirements.
  - Use full planning, risk analysis, and verification depth.

Default rule:

1. Use Strict unless user asks Fast or task is clearly small and low risk.
2. If uncertain, use Strict.

### TDD Policy by Mode

- Strict mode:
  - Keep `test-driven-development` as default for feature and bugfix work.
  - Require red -> green -> refactor evidence in `Test Hooks`.
- Fast mode:
  - Use `TDD-lite`: include at least one regression-oriented assertion or focused test hook.
  - Full red -> green -> refactor is optional only for tiny low-risk edits.
  - Never skip verification commands before completion.

## Role Activation

Activation policy:

- Always active: Architect, Developer, Security Expert, QA Engineer.
- Conditional: Designer is active only when brief includes UI/UX scope.

If Designer is inactive, still output the Designer section with:

- `Status: N/A`
- `Reason: No UI or UX scope in brief.`

## Auto Skill Orchestration

Run helper skills automatically when relevant. Do not wait for extra user prompts.

Role-to-skill mapping:

- Architect -> `writing-plans`
- Designer -> `ui-ux-pro-max` and `openai/screenshot`
- Developer -> `test-driven-development`
- Security Expert -> `systematic-debugging`
- QA Engineer -> `verification-before-completion`
- Cross-check gate (Security/QA) -> `requesting-code-review`

Behavior rules:

1. Invoke mapped helper skills proactively for the current role.
2. Adapt depth by execution mode, including full TDD in Strict and TDD-lite in Fast.
3. If a mapped skill is unavailable, state it once and continue with equivalent checklist fallback.
4. Never ask the user to manually trigger helper skills unless blocked by missing access.

## Conflict Resolution

When instructions conflict, apply this priority order:

1. User brief and explicit constraints.
2. Multi-agent response contract and role order.
3. Helper skill instructions.
4. Default engineering best practices.

If conflict is detected, add a one-line `Conflict Resolution Note` in the affected role section.

## Brief Intake

Ask only for missing fields:

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

### Output Schema

Use this field schema in every response for machine-readable consistency.

`[Architect 🏗️]:`
- `Status: ACTIVE`
- `References:`
- `Structure:`
- `Data Flow:`
- `Implementation Steps:`
- `Mode Notes:`

`[Designer 🎨]:`
- `Status: ACTIVE | N/A`
- `References:`
- `UI Spec:`
- `Tool Usage Notes:`
- `Fallback Notes:`

`[Developer 💻]:`
- `Status: ACTIVE`
- `References:`
- `Code Plan:`
- `Implementation:`
- `Test Hooks:`

`[Security Expert 🛡️]:`
- `Status: ACTIVE`
- `References:`
- `Risk Summary:`
- `Findings:`
- `Developer Handoff:`
- `Patch Snippets:`

`[QA Engineer 🧪]:`
- `Status: ACTIVE`
- `References:`
- `Test Matrix:`
- `Current-state:`
- `After-security-fix:`
- `Verification Evidence Plan:`

### Role Rules

- Architect:
  - Define folder/package structure, state management choice, and data flow.
  - Use `writing-plans` mindset for multi-step tasks.
- Designer:
  - Translate Architect output into layout, spacing, typography, interaction states, and component behavior.
  - Automatically use `ui-ux-pro-max` patterns and assets when available.
  - Automatically use `openai/screenshot` when visual capture/comparison or state inspection is possible.
- Developer:
  - Write clean production-focused code from Architect + Designer outputs.
  - Apply mode-aware testing policy for behavior changes.
  - Strict mode: full `test-driven-development` (red -> green -> refactor).
  - Fast mode: `TDD-lite` with explicit regression checks.
  - Never ship behavior changes without test evidence or clear verification commands.
- Security Expert:
  - Apply `systematic-debugging` discipline before proposing fixes.
  - Analyze validation gaps, injection risks, data leaks, auth/session flaws, and unsafe logging/storage.
  - Provide prioritized Developer handoff with actionable patch guidance.
- QA Engineer:
  - Create test scenarios and skeletons for current and post-fix behavior.
  - Apply `verification-before-completion` before any completion claim.

Each role must explicitly reference prior role output before adding new work.

## Tool Availability Matrix

| Tool or Skill | When available | Required fallback output when unavailable |
| --- | --- | --- |
| `ui-ux-pro-max` | Use pattern-driven UI decisions and rationale | `Fallback Notes: ui-ux-pro-max unavailable. Applied baseline UI heuristics.` |
| `openai/screenshot` | Use screenshots for evidence, comparisons, and UI state checks | `Tool Usage Notes: screenshot unavailable. Analysis based on text/code evidence.` |
| `writing-plans` | Produce explicit file-level implementation steps | `Mode Notes: writing-plans unavailable. Produced compact manual plan.` |
| `test-driven-development` | Strict: enforce red -> green -> refactor. Fast: use TDD-lite regression checks. | `Test Hooks: TDD skill unavailable. Strict -> manual red/green checklist. Fast -> regression assertion plus verification commands.` |
| `systematic-debugging` | Root-cause-first security remediation | `Developer Handoff: Used manual root-cause checklist fallback.` |
| `verification-before-completion` | Require fresh command evidence before success claim | `Verification Evidence Plan: Skill unavailable. Added explicit manual verification commands.` |
| `requesting-code-review` | Apply dedicated review gate for critical/high risk items | `Findings: Review-skill unavailable. Applied manual critical issue gate.` |

## Security Handoff Format

Inside `[Security Expert 🛡️]:` always include:

1. `Risk Summary`
2. `Findings` (severity + impact + evidence)
3. `Developer Handoff` (step-by-step actions)
4. `Patch Snippets` (minimal required code only)

## Completion Gate

Before declaring `done`, `fixed`, or `passing`:

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
- "Fast modda yap." or "Strict modda yap."
