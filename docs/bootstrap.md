# C++ Agent Forge Bootstrap Guide

## Consumer inputs

A C++ consumer repository must provide:

- Repository name and default branch.
- CMake configure/build/test commands.
- Formatting, lint, and sanitizer commands.
- Supported compilers and platforms.
- Protected paths and ownership rules.
- Branch naming and Conventional Commit policy.
- Required reviewers and merge policy.
- Maximum parallel workers and retry policy.

Do not persist local absolute filesystem paths. Use environment variables or paths relative to the checkout.

## Naming contract

The consumer task manifest must provide a PR title and short brief. The orchestrator must generate:

```text
PLAN - <initiative> - <brief>
IMPLEMENT - PR #<number> - <pr-title>
REVIEW - PR #<number> - <pr-title>
```

Use the same PR title and brief in the task record, first chat message, PR title/body, branch metadata, commit context, CI artifact name, and review session.

## C++ generated files

The bootstrap CLI will generate:

- `AGENTS.md`: C++ repository instructions.
- `.codex/project.yml`: metadata, commands, scopes, and model routing.
- `.github/workflows/cpp-ci.yml`: GCC, Clang, tests, formatting, and sanitizers.
- `.github/pull_request_template.md`: scope, tests, and risk checklist.
- `docs/agent-workflow.md`: consumer-specific agent workflow.
- `scripts/`: project-local validation wrappers when required.

## Suggested task manifest

```yaml
task_id: unique-task-id
pr_number: null
pr_title: "Short, action-oriented PR title"
brief: "One-sentence description of the intended change"
repository: owner/name
base_branch: main
branch: codex/task-name
allowed_paths:
  - src/**
  - tests/**
dependencies: []
model: gpt-5.6-terra
reasoning_effort: medium
test_command: cmake -S . -B build && cmake --build build && ctest --test-dir build --output-on-failure
status: queued
```

## GitHub review prompt

Review PR <number> in <owner>/<name>. PR title: <pr-title>. Brief: <brief>. Read AGENTS.md and consumer workflow docs. Inspect the complete diff, CI status, and relevant tests. Report actionable findings ordered by severity. Add inline comments for specific defects and a top-level summary. Do not modify, approve, merge, or enable auto-merge.

The bootstrap CLI is introduced in Phase 2.
