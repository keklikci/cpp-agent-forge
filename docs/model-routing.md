# Model Routing

This document records the recommended model and reasoning-effort policy for
C++ Agent Forge orchestration work. It is a maintainer reference and is not
generated into consumer repositories by default.

## Default routing

| Role | Model | Reasoning effort | Primary use |
| --- | --- | --- | --- |
| Plan | `gpt-5.6-sol` | `high` | Architecture, ambiguity, migrations, orchestration design |
| Implement | `gpt-5.6-terra` | `medium` | Normal implementation, tests, documentation, tooling |
| Simple implementation | `gpt-5.6-luna` | `low` | Mechanical edits, formatting, straightforward docs |
| Review | `gpt-5.6-terra` | `high` | Complete PR review with repository and GitHub context |
| Security/high-risk review | `gpt-5.6-sol` | `high` or `xhigh` | Permissions, concurrency, CI, secrets, data loss, history changes |

## Bootstrap and tooling recommendation

For normal bootstrap CLI, tooling, documentation, and test implementation work,
use:

```text
Model: gpt-5.6-terra
Reasoning effort: medium
Task: implement bin/cpp-agent-forge with init, check, and help
```

Use `gpt-5.6-sol` with high effort when the task requires decisions about
orchestration architecture, permissions, failure recovery, or public interfaces.

## Effort policy

- Start with `medium` for implementation and `high` for planning/review.
- Use `low` for repetitive work only after the scope and acceptance criteria
  are already fixed.
- Increase to `high` when tests, tool use, or cross-file reasoning reveal
  meaningful uncertainty.
- Use `xhigh` for high-risk review when an additional verification pass is
  worth the latency and cost.
- Reserve `max` for exceptional quality-first work; do not use it as the
  default batch setting.

## Session policy

Every session should state its role, model, effort, PR identity, brief, scope,
branch, and repository. Use the canonical names:

```text
PLAN - <initiative> - <brief>
IMPLEMENT - PR #<number> - <pr-title>
REVIEW - PR #<number> - <pr-title>
```

If the execution surface cannot set the chat title, put the identity in the
first message instead.

## Safety boundaries

- Agents must not expose credentials, user paths, or private repository data.
- Review agents may comment or request changes, but must not merge by default.
- Model selection does not grant permissions; GitHub access remains controlled
  by the connected integration and repository policy.
- Record the selected model and effort in the task manifest for reproducibility.

## Source

For current model IDs and reasoning-effort capabilities, consult the official
OpenAI model guidance:

<https://developers.openai.com/api/docs/guides/latest-model>
