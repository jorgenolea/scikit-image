# SYNTH: fictional Acme training ticket

## Ticket: ACME-101
### Title: Validate empty input array in threshold_otsu

### Problem
When an empty image (array with `size == 0`, e.g., `np.array([])` or shape `(0, 5)`) is passed to `threshold_otsu` without a precomputed histogram, execution fails with an unhandled `IndexError` inside the constant-image shortcut (`first_pixel = image.reshape(-1)[0]`). It should raise a clear and standard library `ValueError` instead.

### Expected behaviour
When `image` is empty (`image.size == 0`) and `hist is None`, `threshold_otsu` should raise a `ValueError` with the project-consistent error message:
`The parameter `image` cannot be an empty array`

When `image` is empty but a valid `hist` is provided, `threshold_otsu` should ignore the empty `image`, bypass the constant-pixel shortcut, and compute the threshold using the provided histogram.

Non-empty input images and existing threshold calculation behaviour must remain unaffected.

### Acceptance criteria
- An empty image without `hist` raises `ValueError` with the project-consistent error message: `"The parameter `image` cannot be an empty array"`.
- Empty arrays with different shapes are covered (e.g. 1D empty array `np.array([])` and multidimensional array with a zero-length axis like `(0, 5)`).
- An empty image with a valid histogram still uses that histogram and returns the computed threshold.
- Existing non-empty-image behaviour is preserved.
- Regression tests cover the change across test suites (`tests/skimage/filters/test_thresholding.py` and `tests/skimage2/filters/test_thresholding.py`).
- NumPy-style docstring includes a `Raises` section documenting the `ValueError`.
- Document the bug fix using the repository's current contribution and release-note process; include appropriate text in the PR draft.

### Out of scope
- Calling `check_nD` (which restricts array dimensionalities outside threshold_otsu's accepted arbitrary rank).
- Deprecation cycles (the current `IndexError` is an unhandled exception rather than supported behaviour).
- Gallery examples or tutorials.
