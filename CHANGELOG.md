# Changelog

## Unreleased

## 1.4.0 (2026-05-31)

### New Features

- feat: Add `reuse-filter` attribute that transforms reused content with `shift-headings=N`, `take=N`, and `id-remap=old->new` key/value pairs.
- feat: Add `reuse-take` attribute as a shortcut for partial reuse of the first N top-level blocks.
- feat: Substitute `{{name}}` tokens inside reused content with values from the `div-reuse.vars` metadata namespace, including dotted paths for nested keys.
- feat: Enforce an optional document-level `div-reuse.limit` that caps the number of times each source div may be reused.

### Bug Fixes

- fix: Reset per-document module-level state in a `Meta` pass to prevent leakage across batch renders.
- fix: Deep-clone reused content so per-reuse transforms do not mutate the source div.

### Documentation

- docs: Document reuse into class-bearing divs, the limitation that Quarto smart callouts are expanded before user filters, the precedence of `reuse-take` over `reuse-filter` take, and the new metadata namespace.

## 1.3.1 (2026-04-15)

### Refactoring

- refactor: Synchronise shared module (`logging.lua`) with canonical version.

## 1.3.0 (2026-03-23)

### Refactoring

- refactor: Replace monolithic `utils.lua` with focused modules (`string.lua`, `logging.lua`, `metadata.lua`, `pandoc-helpers.lua`, `html.lua`, `paths.lua`, `colour.lua`).

## 1.2.1 (2026-02-21)

### New Features

- feat: Rename element-attributes to attributes in schema (#14).

## 1.2.0 (2026-02-21)

### New Features

- feat: Add extension-provided code snippets (#12).
- feat: Add _schema.yml for configuration validation and IDE support (#9).

## 1.1.2 (2026-02-11)

## 1.1.1 (2026-02-01)

### Bug Fixes

- fix: Track nested-identifier warning for reused divs.
- fix: Update copyright year.
- fix: Use british english spelling.

## 1.1.0 (2025-10-25)

### New Features

- feat: Update metadata and enhance format options in example.qmd.
- feat: Enhance div reuse functionality and documentation (#4).

### Documentation

- docs: Add output section for example.qmd in README.
- docs: Enhance documentation.
- docs: Add new filter processing phase.

## 1.0.1 (2025-04-05)

### New Features

- feat: Add CITATION file for project citation.

### Documentation

- docs: Note about cross-ref (#1).

## 1.0.0 (2025-02-05)

## 0.1.0 (2025-02-04)

### Bug Fixes

- fix: Rm reuse count.
- fix: No identifier changes.

### Documentation

- docs: Correct command to install.
- docs: Add important note.
