# C++ Agent Forge Handoff

## Objective

Create a reusable C++ repository automation kit that dispatches isolated agents for planning, implementation, CI, and GitHub pull-request review.

Each task gets one owner, one branch, one worktree, and one pull request. The kit is C++-specific; Python automation belongs in a separate future kit.

## Package identity

- Package: `cpp-agent-forge`
- Abbreviation: `CAF`
- Domain: C++ repository automation
- Default standard: C++17
- Build system: CMake
- Test runner: CTest

## Operating model

task queue -> planner -> scoped implementer -> CI -> reviewer -> human merge

Never run write agents in the same mutable worktree. Require disjoint path ownership or serialize dependent tasks.

## Required task identity

Every task must define:

- `task_id`
- `pr_title`
- `brief`
- `repository`
- `base_branch`
- `branch`
- `allowed_paths`

The orchestrator must derive and persist:

- Planning chat: `PLAN - <initiative> - <brief>`
- Implementation chat: `IMPLEMENT - PR #<number> - <pr_title>`
- Review chat: `REVIEW - PR #<number> - <pr_title>`

If the execution surface cannot set a chat title, put the canonical title and brief in the first message. Reuse the same PR number, title, and brief in branch metadata, PR title/body, commit context, CI artifact name, and review session.

Every session must begin with:

```text
PR: #<number> - <pr_title>
Brief: <brief>
Scope: <allowed_paths>
Branch: <branch>
Repository: <owner/name>
```

Do not put local absolute paths, usernames, tokens, or private data in names or persisted metadata.

## C++ repository policy

Generated consumer guidance will require or recommend:

- C++17 and CMake 3.20+.
- Out-of-tree builds and CTest.
- `-Wall -Wextra -Wpedantic` for GCC and Clang.
- clang-format checks.
- clang-tidy when available.
- AddressSanitizer and UndefinedBehaviorSanitizer.
- Explicit ownership and synchronization.
- No unbounded loops in test paths.
- Documentation for platform-specific behavior.

## Roles

Planner: inspect the repository, define acceptance criteria, identify file ownership, dependencies, commands, and risks. Produce a decision-complete brief without editing production files.

Implementer: work only in the assigned branch and path scope, implement the brief, run checks, push the branch, and open or update one PR.

Reviewer: inspect PR metadata, the complete diff, CI, relevant history, and tests. Add actionable inline comments and a top-level summary through GitHub. Do not modify or merge the implementation branch.

## Model routing

Plan: `gpt-5.6-sol`, reasoning effort `high`.
Implement: `gpt-5.6-terra`, reasoning effort `medium`.
Simple or high-volume implementation/docs: `gpt-5.6-luna`, reasoning effort `low`.
Review: `gpt-5.6-terra`, reasoning effort `high`.
Security, permissions, concurrency, CI, or data-loss review: `gpt-5.6-sol`, reasoning effort `high` or `xhigh`.

## GitHub review policy

The GitHub integration is account-level. The reviewer may read repositories, PRs, diffs, commits, workflow results, and artifacts; add inline comments; submit COMMENT or REQUEST_CHANGES reviews; and add top-level comments.

By default the reviewer may not approve its own PR, merge, enable auto-merge, push implementation changes, alter branch protection, or change repository permissions.

## First clean session

Read this file, `README.md`, and `docs/bootstrap.md`. Then implement the bootstrap CLI in a separate phase.
