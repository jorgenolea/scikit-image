# AGENTS.md

## Project

scikit-image is a Python library of algorithms for image processing and computer vision. The import name is `skimage`.

## Layout

- `src/_skimage2/` holds the implementation, including Cython extensions (`.pyx`).
- `src/skimage/` is the public `skimage` package. Modules such as `filters` re-export the `_skimage2` implementation.
- `src/skimage2/` is the public `skimage2` package.
- `tests/skimage/` and `tests/skimage2/` are the matching test trees, split by subpackage (`filters`, `morphology`, `measure`, and the rest). Shared pytest setup is `tests/conftest.py`. `tests/skimage/future/` exists only on the `skimage` side.
- `doc/` holds the Sphinx docs and gallery examples. The project builds with Meson (`meson.build`, `pyproject.toml`).

## Environment

Activate the appropriate Python development environment before building or running tests.

## Commands

Build:

```
spin install -v
```

Focused tests:

```
spin test -- -k otsu
```

Lab 1 verified this thresholding file command:

```
python -m pytest tests/skimage/filters/test_thresholding.py tests/skimage2/filters/test_thresholding.py
```

## Cursor Cloud specific instructions
