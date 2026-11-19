# Filters

- This folder contains the filter implementations. `src/skimage/filters/` and `src/skimage2/filters/` may expose the same functions.
- Matching tests for both API trees live in `tests/skimage/filters/` and `tests/skimage2/filters/`.
- Run the thresholding tests with:

```
spin test -- tests/skimage/filters/test_thresholding.py tests/skimage2/filters/test_thresholding.py
```
