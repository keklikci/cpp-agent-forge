# C++ Agent Forge

C++ repository automation for autonomous planning, implementation, and pull-request review agents.

CAF is a reusable GitHub template and portable shell/CMake bootstrap kit for C++ repositories. It encodes C++17, CMake, CTest, compiler warnings, formatting, static analysis, sanitizer, and Codex agent-orchestration conventions.

## Bootstrap contract

1. Run `bin/cpp-agent-forge init <target-directory>` for a C++ consumer repository.
2. Replace placeholders in `.codex/project.yml`.
3. Add project-specific instructions to `AGENTS.md`.
4. Validate the generated workflow in a fixture repository or branch.
5. Require CI and human approval before merging.

Every task must carry a PR title and brief description. CAF also defines the orchestration contract for Codex: independent features run in separate worktrees and branches, each gets its own PR, overlapping paths are serialized, and human approval remains required before merge. See [docs/agent-orchestration.md](docs/agent-orchestration.md).

CAF is usable by consumer repositories immediately in Codex, but it does not replace Codex or GitHub access. Codex is the execution host that creates subagents, invokes worktree/GitHub operations, runs CI and review, and reports progress; CAF supplies the instructions, manifest, helper, and safety boundaries that make that behavior consistent.

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

## Start a new project

The repository includes a minimal CMake/CTest starter so a template copy is
buildable immediately. For an existing or template-created consumer repo, run:

```sh
bin/cpp-agent-forge init .
bin/cpp-agent-forge check .
scripts/validate-cpp.sh
```
