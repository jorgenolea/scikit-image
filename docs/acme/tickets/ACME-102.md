# SYNTH: fictional Acme training ticket

## Ticket: ACME-102
### Title: Document and test empty-array NaN behaviour in threshold_li

### Task type
Characterization and documentation. `threshold_li` already returns NaN for an empty image. New tests are expected to pass before any implementation changes. Do not manufacture a failure, and do not change the return value to satisfy a test-first workflow.

### Problem
An empty image (an ndarray with `size == 0`, for example `np.array([])` or shape `(0, 5)`) passed to `threshold_li` returns NaN through the existing NaN-stripping shortcut. That result is untested for a genuinely empty array, and the docstring does not mention it. Callers can mistake this for the empty-array `IndexError` that `threshold_otsu` used to raise.

A preliminary reproduction executed only the function's opening statements (`image = image[~np.isnan(image)]`, then `return np.nan` when `image.size == 0`) under NumPy 2.5.4 from `skimage-dev`. Those extracted statements returned `nan` with no warning for empty floating, integer, and boolean arrays, including a zero-length axis. The installed `threshold_li` was not called, because the editable build directory could not be read. The actual function still needs testing.

### Expected behaviour
An empty ndarray returns a NaN threshold. Confirm that by calling `threshold_li` itself.

Images that are all NaN, constant, infinite, or otherwise non-empty keep their current results. The signature stays `threshold_li(image, *, tolerance=None, initial_guess=None, iter_callback=None)`.

The NumPy docstring states that an empty image returns NaN. Keep the existing shape `(M, N[, ...])`.

### Acceptance criteria
- Calling `threshold_li` on a 1-D empty array and on a 2-D array with a zero-length axis yields a NaN threshold, for both a floating dtype and an integer dtype. Assert with `np.isnan(...)`.
- Those tests use synthetic arrays in both `tests/skimage/filters/test_thresholding.py` and `tests/skimage2/filters/test_thresholding.py`.
- The new tests pass before any implementation change.
- The NumPy docstring states that an empty image returns NaN, and it keeps the shape `(M, N[, ...])`.
- All-NaN, constant, infinite, and non-empty results stay as they are.

### Out of scope
- Raising `ValueError`, including the message `The parameter `image` cannot be an empty array`.
- Calling `check_nD`.
- Deprecating the NaN return or otherwise changing runtime behaviour.
- Changing the `0.0` result used when a non-empty image contains only `+inf` and `-inf`.
- Gallery examples or tutorials.
- A release-note bug fix for behaviour that is not changing.
