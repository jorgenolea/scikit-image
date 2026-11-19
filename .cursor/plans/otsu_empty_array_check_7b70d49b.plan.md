---
name: Otsu empty array check
overview: Raise the library's standard empty-array ValueError from threshold_otsu when the image being thresholded has no pixels, instead of the IndexError it raises today.
todos:
  - id: validate
    content: Raise the standard empty-array ValueError in threshold_otsu, skipping the check when hist is provided
    status: pending
  - id: tests
    content: Add matching empty-image tests in both thresholding test modules
    status: pending
  - id: notes
    content: Document the error in the docstring Raises section and release_dev.rst
    status: pending
isProject: false
---

# Validate empty input in threshold_otsu

`threshold_otsu` lives in [`src/_skimage2/filters/thresholding.py`](src/_skimage2/filters/thresholding.py). [`src/skimage/filters/thresholding.py`](src/skimage/filters/thresholding.py) only re-exports it, so the check goes in the implementation.

Today an empty image dies inside the constant-image shortcut:

```381:386:src/_skimage2/filters/thresholding.py
    if image is not None:
        first_pixel = image.reshape(-1)[0]
        if np.all(image == first_pixel):
            return first_pixel
```

`image.reshape(-1)[0]` raises `IndexError` for any array with `size == 0` (`np.array([])`, shape `(0, 5)`, and so on).

## Validation

Do not call `check_nD`. That helper also rejects dimensionalities outside a fixed list, and `threshold_otsu` accepts any rank (`(M, N[, ...])`). Reuse only its message from [`src/_skimage2/_shared/utils.py`](src/_skimage2/_shared/utils.py):

`The parameter `image` cannot be an empty array`

Place the check before the `[0]` index, and only when `image` is the data source. The docstring says a provided `hist` ignores `image`, so:

- `image is not None`, `image.size == 0`, and `hist is None`: raise `ValueError` with that message.
- `image` is empty but `hist` is given: skip the constant-pixel shortcut and continue into `_validate_image_histogram`.

Add a NumPy-style `Raises` section to the `threshold_otsu` docstring for this `ValueError`.

## Tests

Add the same test to both copies, which import the function from each namespace:

- [`tests/skimage/filters/test_thresholding.py`](tests/skimage/filters/test_thresholding.py)
- [`tests/skimage2/filters/test_thresholding.py`](tests/skimage2/filters/test_thresholding.py)

Use `pytest.raises(ValueError, match="cannot be an empty array")`, matching the style of the existing `initial guess` test. Cover a 1D empty array and a 2D zero-length axis. Also assert that an empty image plus a non-empty `hist` still returns a threshold.

## Release note

Add a Bug Fixes bullet to [`doc/source/release_notes/release_dev.rst`](doc/source/release_notes/release_dev.rst) describing the `ValueError` for an empty image passed to `threshold_otsu`. Leave the pull-request link to be filled when the PR exists. No gallery example: this is input validation, not new functionality. No deprecation cycle: the current result is an `IndexError`, not a supported return value.