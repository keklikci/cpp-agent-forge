#!/bin/sh

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cli=$root/bin/cpp-agent-forge
fixture=$(mktemp -d "${TMPDIR-/tmp}/cpp-agent-forge-phase2.XXXXXX")
trap 'rm -rf "$fixture"' EXIT HUP INT TERM

target=$fixture/consumer
mkdir -p "$target/src"

cat > "$target/CMakeLists.txt" <<'EOF'
cmake_minimum_required(VERSION 3.20)
project(caf_fixture LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

enable_testing()
add_executable(caf_fixture src/main.cpp)
add_test(NAME caf_fixture_test COMMAND caf_fixture)
EOF

cat > "$target/src/main.cpp" <<'EOF'
int main() { return 0; }
EOF

$cli init "$target" >/dev/null

expected_files='AGENTS.md .codex/project.yml .github/workflows/cpp-ci.yml .github/pull_request_template.md docs/agent-workflow.md scripts/validate-cpp.sh'
for file in $expected_files; do
    [ -f "$target/$file" ] || {
        printf 'integration fixture missing: %s\n' "$file" >&2
        exit 1
    }
done

check_output=$($cli check "$target")
case "$check_output" in
    *'check: OK'*) ;;
    *)
        printf 'integration fixture failed CAF check\n' >&2
        exit 1
        ;;
esac

if command -v cmake >/dev/null 2>&1 && command -v ctest >/dev/null 2>&1; then
    scripts_output=$(CDPATH= cd "$target" && scripts/validate-cpp.sh)
    case "$scripts_output" in
        *'100% tests passed'*|*'test(s) passed'*) ;;
        *)
            printf 'generated C++ validation did not report passing tests\n' >&2
            exit 1
            ;;
    esac
else
    printf '%s\n' 'CMake/CTest unavailable; skipped fixture build execution.'
fi

grep -F 'PLAN - <initiative> - <brief>' "$target/docs/agent-workflow.md" >/dev/null
grep -F 'IMPLEMENT - PR #<number> - <pr-title>' "$target/docs/agent-workflow.md" >/dev/null
grep -F 'REVIEW - PR #<number> - <pr-title>' "$target/docs/agent-workflow.md" >/dev/null
grep -F 'model: gpt-5.6-terra' "$target/.codex/project.yml" >/dev/null
grep -F 'reasoning_effort: medium' "$target/.codex/project.yml" >/dev/null

printf '%s\n' 'Phase 2 integration tests passed.'
