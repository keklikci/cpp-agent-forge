# C++ Agent Forge

C++ repository automation for autonomous planning, implementation, and pull-request review agents.

CAF is a reusable GitHub template and portable shell/CMake bootstrap kit for C++ repositories. It encodes C++17, CMake, CTest, compiler warnings, formatting, static analysis, sanitizer, and review conventions.

## Bootstrap contract

1. Run `bin/cpp-agent-forge init <target-directory>` for a C++ consumer repository.
2. Replace placeholders in `.codex/project.yml`.
3. Add project-specific instructions to `AGENTS.md`.
4. Validate the generated workflow in a fixture repository or branch.
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

CAF is intentionally C++-specific. Other language kits, if created, should be
maintained as separate projects with their own conventions.

## Use the bootstrap CLI

From this repository, run:

```sh
bin/cpp-agent-forge help
bin/cpp-agent-forge init path/to/consumer-repository
bin/cpp-agent-forge check path/to/consumer-repository
```

The CLI writes only to the target repository and refuses to overwrite existing
generated files unless `CAF_FORCE=1` is set.
