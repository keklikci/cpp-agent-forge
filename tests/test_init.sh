#!/bin/sh

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cli=$root/bin/cpp-agent-forge
fixture=$(mktemp -d "${TMPDIR-/tmp}/cpp-agent-forge-init.XXXXXX")
trap 'rm -rf "$fixture"' EXIT HUP INT TERM

expected_files='AGENTS.md .codex/project.yml .codex/orchestration.yml .github/workflows/cpp-ci.yml .github/pull_request_template.md docs/agent-workflow.md docs/agent-orchestration.md scripts/validate-cpp.sh scripts/caf-worktree.sh'

output=$($cli init "$fixture/consumer")
for file in $expected_files; do
    [ -f "$fixture/consumer/$file" ] || {
        printf 'missing generated file: %s\n' "$file" >&2
        exit 1
    }
    case "$output" in
        *"generated $file"*) ;;
        *)
            printf 'init output omitted generated file: %s\n' "$file" >&2
            exit 1
            ;;
    esac
done

grep 'C++17' "$fixture/consumer/AGENTS.md" >/dev/null
grep 'gpt-5.6-terra' "$fixture/consumer/.codex/project.yml" >/dev/null
grep 'PLAN - <initiative> - <brief>' "$fixture/consumer/docs/agent-workflow.md" >/dev/null
grep 'one task manifest and PR per feature' "$fixture/consumer/docs/agent-orchestration.md" >/dev/null
grep 'max_parallel_tasks: 4' "$fixture/consumer/.codex/orchestration.yml" >/dev/null
grep 'separate worktrees' "$fixture/consumer/AGENTS.md" >/dev/null
grep 'CMAKE_CXX_STANDARD=17' "$fixture/consumer/.github/workflows/cpp-ci.yml" >/dev/null
grep 'Wall -Wextra -Wpedantic' "$fixture/consumer/.github/workflows/cpp-ci.yml" >/dev/null
grep 'clang-format --dry-run --Werror' "$fixture/consumer/.github/workflows/cpp-ci.yml" >/dev/null
grep 'fsanitize=address,undefined' "$fixture/consumer/.github/workflows/cpp-ci.yml" >/dev/null
grep 'ctest --test-dir' "$fixture/consumer/.github/workflows/cpp-ci.yml" >/dev/null

if "$cli" init "$fixture/consumer" >"$fixture/refusal.out" 2>&1; then
    printf 'init unexpectedly overwrote an existing repository\n' >&2
    exit 1
fi
grep 'refusing to overwrite AGENTS.md' "$fixture/refusal.out" >/dev/null

CAF_FORCE=1 "$cli" init "$fixture/consumer" >/dev/null
grep 'Replace placeholders' "$fixture/consumer/.codex/project.yml" >/dev/null

printf '%s\n' 'Init generation tests passed.'
