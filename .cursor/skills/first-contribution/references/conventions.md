# Conventions for a first contribution

Read these sources and apply the ones that match the change. This page does not restate the inventory.

- [Acme conventions inventory](../../../../docs/acme/conventions-inventory.md). Each row names its source and how it is enforced. Rows whose source is SYNTH are lab policy, not scikit-image contributor requirements.

Project instructions:

- [AGENTS.md](../../../../AGENTS.md), and any `AGENTS.md` beside the code you edit.
- Cursor rules: [core-conventions.mdc](../../../rules/core-conventions.mdc), [acme-boundaries.mdc](../../../rules/acme-boundaries.mdc), [tests.mdc](../../../rules/tests.mdc). Read [deprecation.mdc](../../../rules/deprecation.mdc) or [docstrings.mdc](../../../rules/docstrings.mdc) when the change touches a public API or a docstring.
- Upstream documents the inventory cites: [guidelines.md](../../../../doc/source/development/guidelines.md), [testing.md](../../../../doc/source/development/testing.md), [deprecations.md](../../../../doc/source/development/deprecations.md), and [CONTRIBUTING.md](../../../../CONTRIBUTING.md).

Two boundaries already settled for this skill:

- Document the ranks a function actually accepts. The inventory's `(M, N)` form is for a 2D image. Leave an existing arbitrary-rank shape, such as `(M, N[, ...])`, unchanged.
- [acme-boundaries.mdc](../../../rules/acme-boundaries.mdc) requires platform approval before a new runtime dependency. That rule does not cover development or test dependencies.
