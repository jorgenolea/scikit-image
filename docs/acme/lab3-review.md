# Lab 3 review: ACME-101

Review of the skill run for `threshold_otsu` empty-array handling. No commit or pull request was created. Checks were not rerun for this write-up.

## 1. Implementation review

`threshold_otsu(image=None, nbins=256, *, hist=None)` is unchanged.

- Empty input without `hist` raises `ValueError` with `The parameter `image` cannot be an empty array`. The check is `image is not None`, `image.size == 0`, and `hist is None`, before the constant-pixel read.
- Empty input with `hist` skips that shortcut and continues through `_validate_image_histogram`, so the threshold comes from the histogram.
- Non-empty input still uses the existing constant-pixel path: `first_pixel = image.reshape(-1)[0]`, then `np.all(image == first_pixel)`. That branch was not rewritten.
- Eight regression cases: two shapes (`np.array([])` and `(0, 5)`), two behaviours (no histogram, and a valid histogram), and two API trees (`tests/skimage/filters/test_thresholding.py` and `tests/skimage2/filters/test_thresholding.py`). The tests are `test_otsu_empty_image_without_histogram` and `test_otsu_empty_image_uses_histogram`, each parametrized with `1d` and `zero-row`.

The `Raises` section on `threshold_otsu` documents the `ValueError`. The image shape parameter stays `(M, N[, ...])`.

## 2. Recorded verification

Before the fix:

```bash
spin test -- tests/skimage/filters/test_thresholding.py tests/skimage2/filters/test_thresholding.py -k empty_image
```

Result: 8 failed, 234 deselected. Each failure was `IndexError: index 0 is out of bounds for axis 0 with size 0` at `src/_skimage2/filters/thresholding.py:384`.

After the fix, with `~/envs/skimage-dev` activated:

```bash
source /Users/jorge.nole/envs/skimage-dev/bin/activate && .cursor/skills/first-contribution/scripts/check.sh --tests tests/skimage/filters/test_thresholding.py tests/skimage2/filters/test_thresholding.py --files src/_skimage2/filters/thresholding.py tests/skimage/filters/test_thresholding.py tests/skimage2/filters/test_thresholding.py
```

Result: exit 0. `spin test` reported 240 passed and 2 skipped. Both skips are `matplotlib not installed` (`tests/skimage/filters/test_thresholding.py:59` and `tests/skimage2/filters/test_thresholding.py:59`). `pre-commit` passed. Hooks that ran and passed: trailing whitespace, end of files, debug statements, Python AST, mixed line endings, added large files, `ruff check`, and `ruff format`. YAML, JSON, prettier, cython-lint, `generate_requirements.py`, and zizmor were skipped because no matching files were in the file list.

Known limitations from that run:

- Docstring examples were not collected. `check.sh` received only the two test files, and the examples were not changed.
- The new `Raises` section was not checked with a numpydoc build or lint.
- Coverage of the new branch was not measured.
- Only the filters thresholding tests ran. The full suite and CI were not run.
- The run was not repeated with network access blocked. The new tests use synthetic arrays; that was seen by reading them.
- The two matplotlib-dependent tests were skipped, so they were not exercised.
- No category label, human review, commit, or pull request.

The first import of `skimage` in `~/envs/skimage-dev` failed while the editable loader rebuilt. ninja reported `loading 'build.ninja': Operation not permitted`, and the import raised `ImportError: rebuilding the "scikit-image" editable package failed`. Re-running outside the sandbox produced `Editable install of same source detected; skipping build`, and the tests ran. The sandbox or build-access cause remained unconfirmed.

## 3. Rules-only versus skill

These are observations from individual runs, not proof of consistent improvement.

- A rules-only run edited `release_dev.rst`. This conversation did not record that run's diff, command, or check output.
- This skill run did not edit `release_dev.rst` or `doc/source/release_notes/`. The release note was left to the pull-request title.
- This skill run showed the 8 failing tests before the fix, then ran the bundled `check.sh`.

## 4. Draft pull request

**DRAFT.** Not committed, pushed, or opened.

**Title:** `ACME-101: Raise ValueError for an empty image in threshold_otsu`

````markdown
<!--
Upstream. Contribution guide:
https://scikit-image.org/docs/dev/development/contribute.html
AI policy:
https://scikit-image.org/docs/dev/development/contribute.html#ai-policy
-->

`threshold_otsu` raised `IndexError` on an empty image (`size == 0`) because the constant-image shortcut read `image.reshape(-1)[0]`. An empty image with no histogram now raises `ValueError` with the message `The parameter `image` cannot be an empty array`. An empty image with a valid `hist` skips that shortcut and the threshold is computed from the histogram. Non-empty images are unchanged. The signature remains `threshold_otsu(image=None, nbins=256, *, hist=None)`.

A maintainer still needs to add a category label; CI fails on a new pull request until that label is present. The title is enough for the changelist release note.

<!-- Acme additions. Not part of the upstream template. -->

### Ticket

ACME-101: Raise ValueError for an empty image in threshold_otsu

### Problem and change

Empty input reached the constant-pixel shortcut and raised `IndexError`. `threshold_otsu` now rejects an empty `image` when `hist` is missing, and keeps using `hist` when it is provided. The `Raises` section documents that `ValueError`.

### Acceptance criteria

- Empty image without `hist` raises `ValueError` with `The parameter `image` cannot be an empty array`: `test_otsu_empty_image_without_histogram` in `tests/skimage/filters/test_thresholding.py` and `tests/skimage2/filters/test_thresholding.py`.
- 1D `np.array([])` and shape `(0, 5)` are both covered by that test's `1d` and `zero-row` cases.
- Empty image with a valid histogram returns the histogram threshold: `test_otsu_empty_image_uses_histogram` in both files.
- Existing non-empty behaviour is covered by the other tests in those files: 240 passed, 2 skipped.
- NumPy docstring `Raises` section: `threshold_otsu` in `src/_skimage2/filters/thresholding.py`.
- Release note: the title is the changelist text. No `release-note` block, no edit under `doc/source/release_notes/`, no `TODO.txt` reminder.

### Checks

Command, with `~/envs/skimage-dev` activated:

```bash
.cursor/skills/first-contribution/scripts/check.sh --tests tests/skimage/filters/test_thresholding.py tests/skimage2/filters/test_thresholding.py --files src/_skimage2/filters/thresholding.py tests/skimage/filters/test_thresholding.py tests/skimage2/filters/test_thresholding.py
```

```text
Repository root: /Users/jorge.nole/Downloads/uni_application/chamba_applciation/crsr/project1/scikit-image
Test targets:
  tests/skimage/filters/test_thresholding.py
  tests/skimage2/filters/test_thresholding.py
Changed files:
  src/_skimage2/filters/thresholding.py
  tests/skimage/filters/test_thresholding.py
  tests/skimage2/filters/test_thresholding.py

== spin test ==
Invoking `build` prior to running tests:
Editable install of same source detected; skipping build
Editable install of same source directory detected; not setting PYTHONPATH
$ /Users/jorge.nole/envs/skimage-dev/bin/python3 -P -c 'import skimage'
$ /Users/jorge.nole/envs/skimage-dev/bin/python3 -P -m pytest --doctest-plus tests/skimage/filters/test_thresholding.py tests/skimage2/filters/test_thresholding.py
============================= test session starts ==============================
platform darwin -- Python 3.15.0, pytest-9.2.0, pluggy-1.7.0
rootdir: /Users/jorge.nole/Downloads/uni_application/chamba_applciation/crsr/project1/scikit-image
configfile: pyproject.toml
plugins: platformdirs-4.14.5, localserver-0.10.0.post0, cov-7.1.0, pretty-1.3.0, doctestplus-1.7.1
collected 242 items

tests/skimage/filters/test_thresholding.py .s........................... [ 11%]
........................................................................ [ 41%]
....................                                                     [ 50%]
tests/skimage2/filters/test_thresholding.py .s.......................... [ 61%]
........................................................................ [ 91%]
.....................                                                    [100%]

=========================== short test summary info ============================
SKIPPED [1] tests/skimage/filters/test_thresholding.py:59: matplotlib not installed
SKIPPED [1] tests/skimage2/filters/test_thresholding.py:59: matplotlib not installed
Results (5.76s):
       240 passed
         2 skipped
== spin test: PASSED ==

== pre-commit ==
[INFO] Initializing environment for https://github.com/pre-commit/pre-commit-hooks.
[INFO] Initializing environment for https://github.com/rbubley/mirrors-prettier.
[INFO] Initializing environment for https://github.com/rbubley/mirrors-prettier:prettier@3.9.6.
[INFO] Initializing environment for https://github.com/astral-sh/ruff-pre-commit.
[INFO] Initializing environment for https://github.com/MarcoGorelli/cython-lint.
[INFO] Initializing environment for https://github.com/zizmorcore/zizmor-pre-commit.
[INFO] Installing environment for https://github.com/pre-commit/pre-commit-hooks.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
[INFO] Installing environment for https://github.com/rbubley/mirrors-prettier.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
[INFO] Installing environment for https://github.com/astral-sh/ruff-pre-commit.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
[INFO] Installing environment for https://github.com/MarcoGorelli/cython-lint.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
[INFO] Installing environment for https://github.com/zizmorcore/zizmor-pre-commit.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
trim trailing whitespace.................................................Passed
fix end of files.........................................................Passed
debug statements (python)................................................Passed
check python ast.........................................................Passed
mixed line ending........................................................Passed
check yaml...........................................(no files to check)Skipped
check json...........................................(no files to check)Skipped
check for added large files..............................................Passed
prettier.............................................(no files to check)Skipped
ruff check...............................................................Passed
ruff format..............................................................Passed
cython-lint..........................................(no files to check)Skipped
generate_requirements.py.............................(no files to check)Skipped
zizmor...............................................(no files to check)Skipped
== pre-commit: PASSED ==

Result: all checks passed.
```

Exit code: 0.

### AI use

Cursor (Grok 4.7) wrote the regression tests, the empty-array check, the `Raises` section, and this draft.
````
