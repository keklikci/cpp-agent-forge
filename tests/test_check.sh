#!/bin/sh

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cli=$root/bin/cpp-agent-forge
fixture=$(mktemp -d "${TMPDIR-/tmp}/cpp-agent-forge-check.XXXXXX")
trap 'rm -rf "$fixture"' EXIT HUP INT TERM

target=$fixture/consumer
$cli init "$target" >/dev/null

success_output=$($cli check "$target")
case "$success_output" in
    *'check: OK'*) ;;
    *)
        printf 'check did not report success\n' >&2
        exit 1
        ;;
esac

printf '%s\n' '/Users/example/private/build' >> "$target/AGENTS.md"
if "$cli" check "$target" >"$fixture/privacy.out" 2>&1; then
    printf 'check unexpectedly accepted a private path\n' >&2
    exit 1
fi
grep 'privacy scan failed' "$fixture/privacy.out" >/dev/null

CAF_FORCE=1 $cli init "$target" >/dev/null
rm "$target/.github/pull_request_template.md"
if "$cli" check "$target" >"$fixture/missing.out" 2>&1; then
    printf 'check unexpectedly accepted a missing file\n' >&2
    exit 1
fi
grep 'missing .github/pull_request_template.md' "$fixture/missing.out" >/dev/null

printf '%s\n' 'Check validation tests passed.'
