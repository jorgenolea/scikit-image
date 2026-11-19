---
name: first-contribution
description: >-
  Guide a scoped first contribution in this repository,
  from reading a ticket through tests, implementation, checks,
  and a draft pull-request description.
---

# First contribution

Follow this checklist for one scoped ticket. Read the linked files and apply them. Do not copy their rules into the change.

[ACME-101](../../../docs/acme/tickets/ACME-101.md) is an example (empty-array handling in `threshold_otsu`). Its acceptance criteria are not requirements for other tickets.

Steps 1–6 and 8 are judgment. Step 7 is the only scripted check. The script does not read the ticket, compare public signatures, scan dependencies, search tests for network use, or check a pull-request title.

1. Read the supplied ticket and acceptance criteria.
   - Restate expected behaviour, acceptance criteria, and out of scope before editing.

2. Read applicable project instructions and locate implementation/tests.
   - Read [references/conventions.md](references/conventions.md). It points at the conventions inventory, `AGENTS.md`, and the Cursor rules that apply. Do not copy those sources into the change.
   - Find the definition under `src/_skimage2`, re-exports under `src/skimage` and `src/skimage2`, and the matching files in both `tests/skimage` and `tests/skimage2`.
   - Example: `src/_skimage2/filters/thresholding.py`, with tests in `tests/skimage/filters/test_thresholding.py` and `tests/skimage2/filters/test_thresholding.py`.

3. Write a test first and show the result before changing behaviour.
   - Cover the ticket's acceptance criteria in both test trees. Use local fixtures or synthetic arrays.
   - Bug fixes must demonstrate a regression test failing for the expected reason before the fix. Run the new tests with the documented `spin test` command from [AGENTS.md](../../../AGENTS.md) and [testing.md](../../../doc/source/development/testing.md), and show that they fail for the behaviour the ticket describes.
   - Behavior-preserving characterization/documentation tasks should demonstrate the existing behavior with passing tests. Run those tests with the same `spin test` command and show that they pass. Do not manufacture a failure or change behavior to satisfy the workflow.
   - Passing only those test files does not collect docstring examples. `python -m pytest` on test files does not pass `--doctest-plus`. `spin test` adds `--doctest-plus` ([.spin/cmds.py](../../../.spin/cmds.py), default on) but still collects only the paths after `--`.

4. Stop and ask before changing a public signature.
   - Stop if parameters, their order, defaults, the function name, its location, or the return type of a public function would change.
   - State the proposed signature, why it is needed, whether [deprecation.mdc](../../rules/deprecation.mdc) applies, and the alternatives. Wait for a person to approve. Do not continue on an unapproved signature change. See [references/conventions.md](references/conventions.md).
   - Example: ACME-101 leaves `threshold_otsu(image=None, nbins=256, *, hist=None)` unchanged, so this stop does not apply to that ticket.

5. Implement the smallest appropriate change.
   - Change only what the failing test requires.
   - A new runtime dependency needs platform approval first ([acme-boundaries.mdc](../../rules/acme-boundaries.mdc), also noted in [references/conventions.md](references/conventions.md)). That rule does not cover development or test dependencies.

6. Review documentation and deprecation needs.
   - Update the NumPy docstring for the behaviour you changed. Document the ranks the function actually accepts. Keep an existing arbitrary-rank shape, such as `(M, N[, ...])` on `threshold_otsu`. Use `(M, N)` only when the function is 2D ([docstrings.mdc](../../rules/docstrings.mdc), [guidelines.md](../../../doc/source/development/guidelines.md)). The same boundary is in [references/conventions.md](references/conventions.md).
   - Decide whether [deprecation.mdc](../../rules/deprecation.mdc) and [deprecations.md](../../../doc/source/development/deprecations.md) require a cycle. Read the schedule there. Add a `TODO.txt` reminder only when a removal is scheduled.
   - Add a gallery example only when [guidelines.md](../../../doc/source/development/guidelines.md) requires one for new functionality.

7. Run the bundled check script and report its actual output.
   - The script is [scripts/check.sh](scripts/check.sh) next to this skill.
   - If that file is missing, stop and say the check script is missing. Do not claim that tests or style checks passed.
   - When it exists, pass explicit test paths and explicit changed files. Do not let it discover either list. It runs `spin test --` on the test paths and `pre-commit run --files` on the changed files.
   - If docstring examples changed, include the importable module in the test paths (`skimage.<subpackage>` or `_skimage2.<subpackage>`). On an out-of-tree build, `src/` paths are not valid doctest paths ([.spin/cmds.py](../../../.spin/cmds.py)).
   - Report the command and its real output, including a non-zero exit. Do not replace a missing or failed run with a summary.

8. Draft PR text and map results to acceptance criteria.
   - Draft only, using [references/pr-template.md](references/pr-template.md). Do not open or push a pull request unless asked.
   - That file separates upstream requirements ([CONTRIBUTING.md](../../../CONTRIBUTING.md), [.github/PULL_REQUEST_TEMPLATE.md](../../../.github/PULL_REQUEST_TEMPLATE.md)) from Acme additions (ticket-id title, problem and change, acceptance-criteria evidence, actual check output, optional release-note text, and AI-use disclosure only when a tool was used).
