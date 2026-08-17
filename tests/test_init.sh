#!/bin/sh

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cli=$root/bin/cpp-agent-forge
fixture=$(mktemp -d "${TMPDIR-/tmp}/cpp-agent-forge-init.XXXXXX")
trap 'rm -rf "$fixture"' EXIT HUP INT TERM

expected_files='AGENTS.md .codex/project.yml .github/workflows/cpp-ci.yml .github/pull_request_template.md docs/agent-workflow.md scripts/validate-cpp.sh'

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

if "$cli" init "$fixture/consumer" >"$fixture/refusal.out" 2>&1; then
    printf 'init unexpectedly overwrote an existing repository\n' >&2
    exit 1
fi
grep 'refusing to overwrite AGENTS.md' "$fixture/refusal.out" >/dev/null

CAF_FORCE=1 "$cli" init "$fixture/consumer" >/dev/null
grep 'Replace placeholders' "$fixture/consumer/.codex/project.yml" >/dev/null

printf '%s\n' 'Init generation tests passed.'
