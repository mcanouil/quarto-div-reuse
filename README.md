# Div-reuse Extension For Quarto

This is a Quarto extension applying the concept of "code reuse" to the content of a Markdown fenced div.

## Installation

```bash
quarto add mcanouil/quarto-div-reuse@1.4.0
```

This will install the extension under the `_extensions` subdirectory.

If you're using version control, you will want to check in this directory.

## Usage

To activate the filter, add the following to your YAML front matter:

- Old (<1.8.21):

  ```yml
  filters:
    - quarto
    - div-reuse
  ```

- New (>=1.8.21):

  ```yml
  filters:
    - path: div-reuse
      at: post-quarto
  ```

Then, you can reuse any fenced div by using their ID in the following way:

```markdown
## Original Div

::: {#my-div}
{{< lipsum >}}
:::

## Reused Div

::: {reuse="my-div"}
:::
```

> [!IMPORTANT]
> The `reuse` attribute acts like a copy-paste of the original `div` content.
> Consequently, content and their attributes, including identifiers, are duplicated.
> This can result in unexpected behaviour if the same identifier is used multiple times within the same document.
> Prefer the `reuse-filter` `id-remap` transform (see below) when the reused content carries identifiers.

## Reuse transforms

The `reuse-filter` attribute applies one or more transforms to the reused content before it is inserted.
The value is a comma-separated list of `key=value` pairs.
Supported keys are:

- `shift-headings=N`: shift every heading level inside the reused content by `N` (positive deepens, negative promotes).
  Resulting levels are clamped to `[1, 6]` with a warning when clamping occurs.
- `take=N`: keep only the first `N` top-level blocks of the reused content (partial reuse).
- `id-remap=old1->new1;old2->new2`: rename element identifiers on `Div`, `Span`, and `Header` elements in the reused content.
  Use `;` to separate mappings.

The dedicated `reuse-take` attribute is a shortcut for `take=N` and takes precedence over a `take` key in `reuse-filter`.

```markdown
::: {reuse="report" reuse-filter="shift-headings=1,take=2"}
:::

::: {reuse="figure-block" reuse-filter="id-remap=fig-source->fig-copy"}
:::

::: {reuse="report" reuse-take="1"}
:::
```

## Variable substitution

Tokens of the form `{{name}}` (with optional whitespace and dotted paths for nested keys) inside reused content are replaced with values from the `div-reuse.vars` metadata namespace.
Unknown variables are left literal and emit a single warning per name.

```yml
div-reuse:
  vars:
    project: "Quarto Extensions"
    author:
      name: "Mickaël Canouil"
```

```markdown
::: {#greeting}
Hello from {{project}}, signed {{author.name}}.
:::

::: {reuse="greeting"}
:::
```

## Reuse limit

The optional `div-reuse.limit` metadata caps how many times each source div may be reused per document.
Additional reuses beyond the limit are skipped with a warning.

```yml
div-reuse:
  limit: 3
```

## Reusing into class-bearing divs

A reuse destination may carry any classes or attributes the document needs.
Only the children are replaced; the destination div's classes, identifier, and other attributes are preserved.

```markdown
::: {#card-body}
Remember to commit early and often.
:::

::: {.bordered .p-3 reuse="card-body"}
:::
```

> [!NOTE]
> Quarto's smart callouts (`.callout-tip`, `.callout-note`, ...) are expanded before user filters run, so a `reuse` attribute on a `.callout-*` div fills the underlying div but not the rendered callout body.
> To reuse content into a callout, place the callout inside the source div and reuse it as a whole.

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

Output of `example.qmd`:

- [HTML](https://m.canouil.dev/quarto-div-reuse/)
- [Typst/PDF](https://m.canouil.dev/quarto-div-reuse/div-reuse-typst.pdf)
- [LaTeX/PDF](https://m.canouil.dev/quarto-div-reuse/div-reuse-latex.pdf)
- [Word/Docx](https://m.canouil.dev/quarto-div-reuse/div-reuse-openxml.docx)
- [Reveal.js](https://m.canouil.dev/quarto-div-reuse/div-reuse-revealjs.html)
- [Beamer/PDF](https://m.canouil.dev/quarto-div-reuse/div-reuse-beamer.pdf)
- [PowerPoint/Pptx](https://m.canouil.dev/quarto-div-reuse/div-reuse-pptx.pptx)
