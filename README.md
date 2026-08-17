# C++ Agent Forge

C++ repository automation for autonomous planning, implementation, and pull-request review agents.

CAF is a reusable GitHub template and portable shell/CMake bootstrap kit for C++ repositories. It encodes C++17, CMake, CTest, compiler warnings, formatting, static analysis, sanitizer, and review conventions.

## Bootstrap contract

1. Copy or initialize the kit in a new C++ consumer repository.
2. Replace placeholders in `.codex/project.yml`.
3. Add project-specific instructions to `AGENTS.md`.
4. Validate the generated workflow on a fixture branch.
5. Require CI and human approval before merging.

Every task must carry a PR title and brief description. The orchestrator uses them consistently in chat/session names, first-message headers, branches, PRs, commits, CI artifacts, and review sessions.

Package name: `cpp-agent-forge`. Short name: `CAF`.

## C++ defaults

- C++17.
- CMake 3.20 or newer.
- CTest for test execution.
- GCC and Clang on Linux.
- `-Wall -Wextra -Wpedantic`.
- clang-format and optional clang-tidy.
- AddressSanitizer and UndefinedBehaviorSanitizer.

The future Python kit will be a separate sibling project.

## Initialize the template repository

```sh
git init
git branch -M main
git add README.md HANDOFF.md CONTRIBUTING.md docs/
git commit -m "docs(cpp-agent-forge): define C++ orchestration kit identity"
git remote add origin git@github.com:USERNAME/cpp-agent-forge.git
git push -u origin main
```

The bootstrap CLI is added in the next phase.
