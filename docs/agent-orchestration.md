# Agent Orchestration

CAF supplies a Codex-ready orchestration contract for consumer repositories.
The orchestration policy is generated into `.codex/orchestration.yml` and is
enforced by the repository instructions in `AGENTS.md`.

## Behavior for user requests

For a request containing multiple independently deliverable features, the
orchestrator must:

1. Create one task manifest per feature with a unique `task_id`, PR title,
   brief, owned paths, dependencies, and validation commands.
2. Plan the full request before implementation and identify path overlap.
3. Start independent implementation agents in separate Git worktrees and
   branches named `codex/<task-slug>`.
4. Serialize tasks that modify overlapping paths or depend on unfinished work.
5. Give each completed task its own PR. A PR must include its task identity,
   scope, validation results, and risk notes.
6. Run a review agent against the complete diff and CI result before asking the
   user for approval. Review agents may request changes but must not merge.

Unless the user explicitly requests a single combined PR, independent features
must not be collapsed into one implementation branch or PR.

The default maximum parallelism is four tasks. Consumer repositories may lower
this in `.codex/orchestration.yml`.

## What CAF does and does not automate

CAF provides the policy, manifest shape, worktree helper, branch convention,
CI checks, PR template, and review protocol. Codex remains the execution host:
it creates subagents/worktrees, invokes the helper and GitHub integration, and
reports progress. GitHub permissions, repository secrets, and merge approval
are intentionally not bypassed by CAF.

## Worktree helper

From the consumer repository:

```sh
scripts/caf-worktree.sh create task-id main
scripts/caf-worktree.sh list
scripts/caf-worktree.sh remove task-id
```

The default worktree directory is `../.caf-worktrees`; set
`CAF_WORKTREE_ROOT` to override it. Worktrees must not be nested inside the
consumer repository or share a branch.
