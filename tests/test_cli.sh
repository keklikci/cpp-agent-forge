#!/bin/sh

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cli=$root/bin/cpp-agent-forge

assert_contains() {
    haystack=$1
    needle=$2
    case "$haystack" in
        *"$needle"*) ;;
        *)
            printf 'expected output to contain: %s\n' "$needle" >&2
            exit 1
            ;;
    esac
}

help_output=$($cli help)
assert_contains "$help_output" "cpp-agent-forge init <target-directory>"
assert_contains "$help_output" "cpp-agent-forge check <target-directory>"
assert_contains "$help_output" "cpp-agent-forge help"

if "$cli" unknown >/tmp/cpp-agent-forge-test.out 2>&1; then
    printf 'unknown command unexpectedly succeeded\n' >&2
    exit 1
fi
unknown_output=$(sed -n '1,3p' /tmp/cpp-agent-forge-test.out)
assert_contains "$unknown_output" "unknown command: unknown"

if "$cli" init >/tmp/cpp-agent-forge-test.out 2>&1; then
    printf 'init without target unexpectedly succeeded\n' >&2
    exit 1
fi
missing_target_output=$(sed -n '1,3p' /tmp/cpp-agent-forge-test.out)
assert_contains "$missing_target_output" "init requires a target directory"

if "$cli" help extra >/tmp/cpp-agent-forge-test.out 2>&1; then
    printf 'help with extra argument unexpectedly succeeded\n' >&2
    exit 1
fi
extra_help_output=$(sed -n '1,3p' /tmp/cpp-agent-forge-test.out)
assert_contains "$extra_help_output" "help does not accept arguments"

printf '%s\n' 'CLI argument tests passed.'
