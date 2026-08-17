# Contributing to C++ Agent Forge

CAF is a C++ repository automation kit. Keep the template itself portable, privacy-safe, and independent of any consumer repository.

## Documentation and metadata

- Never persist absolute user paths, usernames, tokens, or private repository names.
- Keep C++17, CMake, CTest, GCC/Clang, formatting, and sanitizer guidance consistent.
- Keep PR titles and briefs synchronized with chat and review naming conventions.
- Use relative paths and placeholders in generated files.

## Commits

Use Conventional Commits with a meaningful scope:

```text
feat(bootstrap): add consumer workflow generator
```

## Validation

Before submitting a change, run shell syntax checks, inspect generated output, and validate that no user-specific paths or secrets are present.
