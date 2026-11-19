#!/usr/bin/env bash
# Run targeted tests and pre-commit on paths the caller supplies.
# This script does not discover files, install tools, or skip a missing command.

set -eu

usage() {
  cat <<'EOF'
Usage: check.sh --tests TEST... --files FILE...

Run these commands from the repository root:
  spin test -- TEST...
  pre-commit run --files FILE...

Both --tests and --files are required, and each needs at least one path.
Paths with spaces must be quoted; each path is passed through unchanged.

Options:
  -h, --help    Show this help and exit.
EOF
}

tests=()
files=()
mode=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    --tests)
      mode="tests"
      shift
      ;;
    --files)
      mode="files"
      shift
      ;;
    --)
      echo "error: pass paths after --tests and --files." >&2
      usage >&2
      exit 2
      ;;
    -*)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [[ -z "$mode" ]]; then
        echo "error: path '$1' is outside --tests and --files." >&2
        usage >&2
        exit 2
      fi
      if [[ -z "$1" ]]; then
        echo "error: empty path in --${mode}." >&2
        usage >&2
        exit 2
      fi
      if [[ "$mode" == "tests" ]]; then
        tests+=("$1")
      else
        files+=("$1")
      fi
      shift
      ;;
  esac
done

if [[ ${#tests[@]} -eq 0 || ${#files[@]} -eq 0 ]]; then
  echo "error: both --tests and --files are required, each with at least one path." >&2
  if [[ ${#tests[@]} -eq 0 ]]; then
    echo "error: no test targets were given." >&2
  fi
  if [[ ${#files[@]} -eq 0 ]]; then
    echo "error: no changed files were given." >&2
  fi
  usage >&2
  exit 2
fi

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd "${script_dir}/../../../.." && pwd)
if [[ ! -f "${repo_root}/pyproject.toml" || ! -f "${repo_root}/meson.build" ]]; then
  echo "error: could not find the repository root above ${script_dir}." >&2
  echo "error: looked at ${repo_root}." >&2
  exit 1
fi
cd "${repo_root}"
echo "Repository root: ${repo_root}"

echo "Test targets:"
for target in "${tests[@]}"; do
  printf '  %s\n' "${target}"
done
echo "Changed files:"
for changed in "${files[@]}"; do
  printf '  %s\n' "${changed}"
done

status=0

run_check() {
  name="$1"
  shift
  echo ""
  echo "== ${name} =="
  if "$@"; then
    echo "== ${name}: PASSED =="
    return 0
  else
    code=$?
    echo "== ${name}: FAILED (exit ${code}) =="
    return 1
  fi
}

if ! command -v spin >/dev/null 2>&1; then
  echo ""
  echo "== spin test =="
  echo "== spin test: FAILED (command not found: spin) =="
  echo "Required command 'spin' is not on PATH. It was not installed, and the tests were not run."
  status=1
elif ! run_check "spin test" spin test -- "${tests[@]}"; then
  status=1
fi

if ! command -v pre-commit >/dev/null 2>&1; then
  echo ""
  echo "== pre-commit =="
  echo "== pre-commit: FAILED (command not found: pre-commit) =="
  echo "Required command 'pre-commit' is not on PATH. It was not installed, and style checks were not run."
  status=1
elif ! run_check "pre-commit" pre-commit run --files "${files[@]}"; then
  status=1
fi

echo ""
if [[ "${status}" -eq 0 ]]; then
  echo "Result: all checks passed."
else
  echo "Result: one or more checks failed."
fi
exit "${status}"
